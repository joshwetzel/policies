require 'test/unit'
require 'active_support/all'
require 'policies'
require 'policies_test'
require 'policies/project_policy_test'

Project = Class.new

Test::Unit::TestCase.class_eval do
  include Policies::Methods
end

def current_user; end
def current_role; end

def action_name
  'edit'
end
