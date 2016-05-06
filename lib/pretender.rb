require "pretender/version"

module Pretender
  def impersonates(scope = :user, opts = {})
    impersonated_method = opts[:method] || :"current_#{scope}"
    impersonate_with = opts[:with] || proc { |id| scope.to_s.classify.constantize.where(:id => id).first }
    true_method = :"true_#{scope}"
    session_key = :"impersonated_#{scope}_id"
    impersonated_var = :"@impersonated_#{scope}"

    # define methods
    if respond_to?(impersonated_method)
      alias_method true_method, impersonated_method
    else
      define_method true_method do
        ActionController::Base.instance_method(impersonated_method).bind(self).call
      end
    end
    helper_method true_method

    define_method impersonated_method do
      unless instance_variable_get(impersonated_var)
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
      session[session_key] = resource.id
    end

    define_method :"stop_impersonating_#{scope}" do
      instance_variable_set(impersonated_var, nil)
      session[session_key] = nil
    end
  end
end
