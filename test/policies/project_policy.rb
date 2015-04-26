class ProjectPolicy < Policy
  def show?
    true
  end

  def edit?
    false
  end
end
