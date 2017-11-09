require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    # @user = User.new(name: "Rick Sanchez", email: "rick@sanchez.com",
    #                  password: "password", password_confirmation: "password")
    # @user.save!


    User.create!(
      name: "Rick Sanchez",
      email: "rick@sanchez.com",
      password: "password", 
      ssn: "1234",
      admin: false )

    @user = User.where(name: "Rick Sanchez").take


  end

  teardown do
    @user.delete
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password'}}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_redirected_to overview_user_path # jpp: session redirs to user, who redirs to user#overview. ugh, should short-circuit these redirs.
    follow_redirect!
    # assert_template 'users/show' # jpp: "why verify a template was used?"
    assert_select "a[href=?]", login_path, count: 0, message: "Shouldn't show the Login button if you're logged in."
    assert_select "a[href=?]", logout_path, message: "If logged in, the Logout button should be present."
    assert_select "a[href=?]", user_path(@user), message: "If logged in, user's profile link should be present."
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path, message: "After logout should see login button."
    assert_select "a[href=?]", logout_path,       count: 0, message: "After logout shouldn't see logout button."
    assert_select "a[href=?]", user_path(@user),  count: 0, message: "After logout shouldn't see profile button."
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
