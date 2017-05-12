require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "show user profile page without logged in" do
    get user_url @user
    assert_template 'users/show'
  end
  
  test "show user profile page with logged in" do
    log_in_as @user
    get user_url @user
    assert_template 'users/show'
  end
end
