require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "show users page without logged in" do
    get users_url
    assert_redirected_to login_url
  end
  
  test "index including pagination" do
    log_in_as @user
    get users_url
    
    assert_template 'users/index'
    assert_select 'div.pagination', count:2
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]',user_path(user), test:user.name
    end
  end
  
end
