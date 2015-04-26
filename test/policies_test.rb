require 'test_helper'

class PoliciesTest < Test::Unit::TestCase
  def setup
    @project = Project.new
  end

  test 'symbol conversion' do
    assert_equal authorized?(:show, :project), true
    assert_equal authorized?(:edit, :project), false
  end

  test 'object conversion' do
    assert_equal authorized?(:show, @project), true
    assert_equal authorized?(:edit, @project), false
  end

  test 'unauthorized error raised' do
    assert_raises Policies::UnauthorizedError do
      authorize(@project)
    end
  end
end
