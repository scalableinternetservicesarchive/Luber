require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    User.create!(
        name: 'Rick Sanchez',
        email: 'rick@sanchez.com',
        password: 'password',
        ssn: '1234',
        admin: false
    )

    @user = User.where(name: 'Rick Sanchez').take
  end

  teardown do
    @user.delete
  end

  test 'successful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "foo bar",
                                              email: "foo@bar.com",
                                              password: "password2",
                                              password_confirmation: "password2" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal "foo bar", @user.name
    assert_equal "foo@bar.com", @user.email
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                             email: "invalid@foobar.com",
                                             password: "foo",
                                             password_confirmation: "bar" } }
    assert_template 'users/edit'
  end

end
