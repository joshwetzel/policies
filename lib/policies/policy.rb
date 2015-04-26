class Policy
  attr_reader :current_user, :current_role

  def initialize(current_user, current_role, object)
    @current_user = current_user
    @current_role = current_role

    unless object.is_a?(Symbol)
      instance_variable_set('@' + object.class.to_s.underscore, object)
    end
  end
end
