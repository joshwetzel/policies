class Policy
  attr_reader :user, :role

  def initialize(user, role, object)
    @user = user
    @role = role

    unless object.is_a?(Symbol)
      instance_variable_set('@' + object.class.to_s.underscore, object)
    end
  end
end
