require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    User.create!(
      username: "RickSanchez", 
      email: "rick@sanchez.com", 
      password: "password", 
      password_confirmation: "password")
    @user = User.where(username: "RickSanchez").take
  end

  teardown do
    @user.delete
  end

  test "signin with valid information followed by signout" do
    get signin_path
    post signin_path, params: { session: { email: @user.email, password: 'password'}}
    assert is_signed_in?
    assert_redirected_to overview_user_path(@user)
    follow_redirect!
    assert_template 'users/overview'
    assert_select "a[href=?]", signin_path, count: 0
    assert_select "a[href=?]", signout_path
    assert_select "a[href=?]", overview_user_path(@user)
    delete signout_path
    assert_not is_signed_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", signin_path
    assert_select "a[href=?]", signout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "signin with invalid information" do
    get signin_path
    assert_template 'sessions/new'
    post signin_path, params: {session: {email: "", password: ""}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
