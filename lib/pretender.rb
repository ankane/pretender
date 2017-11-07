require "pretender/version"
require "active_support"

module Pretender
  class Error < StandardError; end

  module Methods
    def impersonates(scope = :user, opts = {})
      impersonated_method = opts[:method] || :"current_#{scope}"
      impersonate_with = opts[:with] || proc { |id|
        klass = scope.to_s.classify.constantize
        primary_key = klass.respond_to?(:primary_key) ? klass.primary_key : :id
        klass.find_by(primary_key => id)
      }
      true_method = :"true_#{scope}"
      session_key = :"impersonated_#{scope}_id"
      impersonated_var = :"@impersonated_#{scope}"

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
        unless instance_variable_defined?(impersonated_var) && instance_variable_get(impersonated_var)
          # only fetch impersonation if user is logged in and impersonation_id exists
          true_resource = send(true_method)
          if session[session_key] && !true_resource
            session[session_key] = nil
          end
          value = (session[session_key] && impersonate_with.call(session[session_key])) || true_resource
          instance_variable_set(impersonated_var, value) if value
        end
        instance_variable_get(impersonated_var)
      end

      define_method :"impersonate_#{scope}" do |resource|
        instance_variable_set(impersonated_var, resource)
        session[session_key] = resource.id.to_s
      end

      define_method :"stop_impersonating_#{scope}" do
        instance_variable_set(impersonated_var, nil)
        session[session_key] = nil
      end
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  extend Pretender::Methods
end
