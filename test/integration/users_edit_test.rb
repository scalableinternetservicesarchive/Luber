require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    User.create!(
        username: 'Rick Sanchez',
        email: 'rick@sanchez.com',
        password: 'password',
        admin: false
    )

    @user = User.where(username: 'Rick Sanchez').take
  end

  teardown do
    @user.delete
  end

  test 'successful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        username: "foo bar",
        email: "foo@bar.com",
        password: "password2",
        password_confirmation: "password2" } }
    assert_not flash.empty?
    assert_redirected_to overview_user_path
    @user.reload
    assert_equal "foo bar", @user.username
    assert_equal "foo@bar.com", @user.email
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        username: "",
        email: "invalid@foobar.com",
        password: "foo",
        password_confirmation: "bar" } }
    assert_template 'users/edit'
  end

end
