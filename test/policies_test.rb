require 'test_helper'

class PoliciesTest < Minitest::Test
  def setup
    @project = Project.new
  end

  def test_symbol_conversion
    assert_equal authorized?(:show, :project), true
    assert_equal authorized?(:edit, :project), false
  end

  def test_plural_symbol_conversion
    assert_equal authorized?(:show, :projects), true
    assert_equal authorized?(:edit, :projects), false
  end

  def test_object_conversion
    assert_equal authorized?(:show, @project), true
    assert_equal authorized?(:edit, @project), false
  end

  def test_unauthorized_error_raised
    assert_raises Policies::UnauthorizedError do
      authorize(@project)
    end
  end
end
