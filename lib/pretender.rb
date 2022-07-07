require "pretender/version"
require "active_support"

module Pretender
  class Error < StandardError; end

  module Methods
    def impersonates(scope = :user, opts = {})
      impersonated_method = opts[:method] || :"current_#{scope}"
      impersonate_with = opts[:with] || proc { |klass, id|
        klass = klass.constantize
        primary_key = klass.respond_to?(:primary_key) ? klass.primary_key : :id
        klass.find_by(primary_key => id)
      }
      true_method = :"true_#{scope}"
      id_session_key = :"impersonated_#{scope}_id"
      klass_session_key = :"impersonated_#{scope}_klass"
      impersonated_var = :"@impersonated_#{scope}"
      stop_impersonating_method = :"stop_impersonating_#{scope}"

      # define methods
      if method_defined?(impersonated_method) || private_method_defined?(impersonated_method)
        alias_method true_method, impersonated_method
      else
        sc = superclass
        define_method true_method do
          # TODO handle private methods
          raise Pretender::Error, "#{impersonated_method} must be defined before the impersonates method" unless sc.method_defined?(impersonated_method)
          sc.instance_method(impersonated_method).bind(self).call
        end
      end
      helper_method(true_method) if respond_to?(:helper_method)

      define_method impersonated_method do
        impersonated_resource = instance_variable_get(impersonated_var) if instance_variable_defined?(impersonated_var)

        if !impersonated_resource && request.session[id_session_key]
          # only fetch impersonation if user is logged in
          # this is a safety check (once per request) so
          # if a user logs out without session being destroyed
          # or stop_impersonating_user being called,
          # we can stop the impersonation
          if send(true_method)
            impersonated_resource = if impersonate_with.arity == 1
                                      impersonate_with.call(request.session[id_session_key])
                                    else
                                      impersonate_with.call(request.session[klass_session_key], request.session[id_session_key])
                                    end
            instance_variable_set(impersonated_var, impersonated_resource) if impersonated_resource
          else
            # TODO better message
            warn "[pretender] Stopping impersonation due to safety check"
            send(stop_impersonating_method)
          end
        end

        impersonated_resource || send(true_method)
      end

      define_method :"impersonate_#{scope}" do |resource|
        raise ArgumentError, "No resource to impersonate" unless resource
        raise Pretender::Error, "Must be logged in to impersonate" unless send(true_method)

        instance_variable_set(impersonated_var, resource)
        # use to_s for Mongoid for BSON::ObjectId
        request.session[id_session_key] = resource.id.is_a?(Numeric) ? resource.id : resource.id.to_s
        request.session[klass_session_key] = resource.class.to_s
      end

      define_method stop_impersonating_method do
        remove_instance_variable(impersonated_var) if instance_variable_defined?(impersonated_var)
        request.session.delete(id_session_key)
        request.session.delete(klass_session_key)
      end
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  extend Pretender::Methods
end

# ActiveSupport.on_load(:action_cable) runs too late with Unicorn
ActionCable::Connection::Base.extend(Pretender::Methods) if defined?(ActionCable)
