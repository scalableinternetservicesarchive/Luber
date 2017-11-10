require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    User.create!(
      name: 'Rick Sanchez',
      email: 'rick@sanchez.com',
      password: 'password',
      ssn: '1234',
      admin: false
    )

    @user = User.where(name: 'Rick Sanchez').take

    User.create!(
      name: 'Morty Sanchez',
      email: 'morty@sanchez.com',
      password: 'password',
      ssn: '1234',
      admin: false
    )

    @other_user = User.where(name: 'Morty Sanchez').take
  end

  teardown do
    @user.delete
    @other_user.delete
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should get new' do
    get new_user_path
    assert_response :success
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
end
