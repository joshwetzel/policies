module Policies::Methods
  def self.included(base)
    base.send(:helper_method, :authorized?) if base.respond_to?(:helper_method)
  end

  def authorize(object)
    raise Policies::UnauthorizedError unless authorized?(action_name, object)
  end

  def authorized?(action, object)
    policy_class(object).constantize.new(current_user, current_role, object).public_send(action.to_s + '?')
  end

  private

  def policy_class(object)
    if object.is_a?(Symbol)
      object.to_s.classify
    else
      object.class.to_s
    end + 'Policy'
  end
end

if defined?(ActionController::Base)
  ActionController::Base.class_eval do
    include Policies::Methods
  end
end
