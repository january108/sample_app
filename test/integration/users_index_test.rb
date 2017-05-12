require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "show users page without logged in" do
    get users_url
    assert_redirected_to login_url
  end
  
  test "show users page with logged in" do
    log_in_as @user
    get users_url
    assert_template 'users/index'
  end
  
end
