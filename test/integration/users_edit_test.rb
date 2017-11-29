require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    User.create!(
        username: 'RickSanchez',
        email: 'rick@sanchez.com',
        password: 'password',
        admin: false)
    @user = User.where(username: 'RickSanchez').take
  end

  teardown do
    @user.delete
  end

  test 'successful edit' do
    sign_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        username: "foobar",
        email: "foo@bar.com",
        password: "password2",
        password_confirmation: "password2" } }
    assert_not flash.empty?
    @user.reload
    assert_redirected_to overview_user_path(@user.username)
    assert_equal "foobar", @user.username
    assert_equal "foo@bar.com", @user.email
  end

  test 'unsuccessful edit' do
    sign_in_as(@user)
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
