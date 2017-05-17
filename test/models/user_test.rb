require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup 
    @user = User.new(name:"example user", email:"user@example.com", 
                    password:"foobar", password_confirmation:"foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  test "name should not be long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end
  
  test "email should not be long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} shoud be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email should be saved as lower-case" do
    mixed_cased_email = "Foo@ExAmPle.Com"
    @user.email = mixed_cased_email
    @user.save
    assert_equal mixed_cased_email.downcase, @user.reload.email
  end
  
  test "password should be present(noblank)" do
    @user.password = @user.password_confirmation = "" * 6
    assert_not @user.valid?
  end
  
  test "password should have a minimum_length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "password digest should be saved" do
    @user.remember
    assert_not_empty @user.remember_digest
  end
  
  test "new_token should be created" do
    assert_not_empty User.new_token
  end

  test "digest should be created" do
    assert_not_empty User.digest(User.new_token)
  end
  
  test "authenticated? should return false for a user with nil digest" do 
    assert_not @user.authenticated?('')
  end
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.created!(content: "Lolem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
end
