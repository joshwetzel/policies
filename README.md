# Policies
[![Gem Version](https://badge.fury.io/rb/policies.svg)](http://badge.fury.io/rb/policies)

Policies is an authorization control library for Ruby on Rails.

It was primarily designed for use in applications where a user's authorization may change depending on a particular
context. For example, in an application where users may belong to one or more projects, it may be ideal for them to edit
the settings of a project they own, but not necessarily edit the settings of a project in which they are a member.

This gem helps facilitate the creation of those authorization rules through simple, well defined Ruby classes.

## Installation
In your Gemfile, include the `policies` gem.

```ruby
gem 'policies'
```

## Prerequisites
Policies makes a few logical assumptions for the ease of implementation.

  1. It requires a `current_user` method to be defined.

    ```ruby
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    ```
  2. It requires a `current_role` method to be defined.

    ```ruby
    # On an intermediary object, such as membership
    def current_role
      if @project.present? && @project.persisted?
        @current_role ||= @project.memberships.find_by(user: current_user).role
      end
    end

    # On the user
    def current_role
      @current_role ||= current_user.role
    end
    ```
  3. The names of policy classes must be a combination of an object's class suffixed with `Policy`. For example, a
     policy for projects should be named `ProjectPolicy`, and a policy for users should be named `UserPolicy`. It is
     recommended to place policies in an `app/policies` directory.
  4. Policies should inherit from `Policies::Base`.
  5. Method names within a policy should be suffixed with a `?`.

## Getting Started
Take the following example, in which a user may belong to one or more projects through an intermediary membership.

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  has_many :memberships
  has_many :projects, through: :memberships
end

# app/models/project.rb
class Project < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
end

# app/models/membership.rb
class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
end

# app/models/role.rb
class Role < ActiveRecord::Base
  def member?
    %w(Member Administrator Owner).include?(name)
  end

  def admin?
    %w(Administrator Owner).include?(name)
  end

  def owner?
    name == 'Owner'
  end
end
```

Imagine a user is an owner of Project A and a member of Project B. In this specific case, the role of the user will
change depending on which project they are viewing. Owners of a project should have the ability to edit its settings or
invite new members, while members of a project should only be allowed to view it.

With that in mind, a new policy class may be created to limit the authorization depending on the current role.

### Creating a New Policy
Within `app/policies`, create a new file named `project_policy.rb`. **Remember to restart your application server to
pick up the new directory.**

```ruby
# app/policies/project_policy.rb
class ProjectPolicy < Policies::Base
end
```

### Limiting Access
Let's assume we want to limit the edit and update actions to a project owner.

```ruby
# app/policies/project_policy.rb
class ProjectPolicy < Policies::Base
  def edit?
    current_role.owner?
  end
  alias_method :update?, :edit?
end
```

An instance variable named after the object's class is also available for use within the policy.

```ruby
# app/policies/project_policy.rb
class ProjectPolicy < Policies::Base
  def destroy?
    @project.can_be_destroyed? && current_role.owner?
  end
end
```

Using a different example, a user may only be allowed to edit their own account.

```ruby
# app/policies/user_policy.rb
class UserPolicy < Policies::Base
  def edit?
    current_user == @user
  end
  alias_method :update?, :edit?
end
```

### Updating Views and Controllers
After the policy is written, views may be updated with the `authorized?` helper.

```erb
<% if authorized?(:edit, @project) %>
  <%= link_to @project, project_path(@project) %>
<% end %>
```

Controllers may be updated with the `authorize` and `authorized?` methods.

```ruby
# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  def edit
    @project = current_user.projects.find(params[:id])
    authorize(@project)
  end

  def update
    @project = current_user.projects.find(params[:id])
    authorize(@project)

    if @project.update(project_params)
      redirect_to @project, success: translate('.success')
    else
      render :edit
    end
  end
end
```

A better, more DRY approach may be using `authorize` in a `before_action`.

```ruby
# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  before_action :set_project, only: [:edit, :update]

  def update
    if @project.update(project_params)
      redirect_to @project, success: translate('.success')
    else
      render :edit
    end
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
    authorize(@project)
  end
end
```

`authorize` will raise `Policies::UnauthorizedError` if the user is restricted from accessing the particular action.

`authorized?` may be used when a boolean should be returned. If no action argument is passed, it will default to the
current action.

```ruby
# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  def edit
    @project = Project.find(params[:id])

    if authorized?(@project)
      ...
    else
      redirect_to projects_path, error: translate('.unauthorized')
    end
  end
end
```

In a situation where an instantiated object is not available, a symbol may be passed to `authorized?` and `authorize`.
If no action argument is passed, it defaults to the current `action_name`.

```erb
<% if authorized?(:index, :projects) %>
  <%= link_to @project, projects_path %>
<% end %>
```

```ruby
# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  def index
    authorize(:projects)
    @projects = current_user.projects
  end
end
```

## Acknowledgments
Special thanks to [Pundit](https://github.com/elabs/pundit) for the inspiration for this project.
