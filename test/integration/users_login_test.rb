require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    User.create!(username: "RickSanchez", email: "rick@sanchez.com", password: "foobar", password_confirmation: "foobar")
    @user = User.where(username: "RickSanchez").take
  end

  teardown do
    @user.delete
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'foobar'}}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    follow_redirect!
    assert_template 'users/overview'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session: {email: "", password: ""}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
