module Policies::Methods
  def self.included(base)
    base.send(:helper_method, :authorized?) if base.respond_to?(:helper_method)
  end

  def authorize(action = action_name, object)
    raise Policies::UnauthorizedError unless authorized?(action, object)
  end

  def authorized?(action = action_name, object)
    policy_class(object).new(current_user, current_role, object).public_send(action.to_s + '?')
  end

  private

  def policy_class(object)
    class_name =
      if object.is_a?(Symbol)
        object.to_s.classify
      else
        object.class.to_s
      end + 'Policy'

    class_name.constantize
  end
end

if defined?(ActionController::Base)
  ActionController::Base.class_eval do
    include Policies::Methods
  end
end
