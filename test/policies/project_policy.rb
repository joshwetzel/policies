class ProjectPolicy < Policies::Base
  def show?
    true
  end

  def edit?
    false
  end
end
