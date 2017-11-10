require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: 'Example User',
                                         email: 'user@example.com',
                                         password: 'foobar',
                                         password_confirmation: 'foobar' } }
    end
    follow_redirect!
    follow_redirect!
    assert_template 'users/overview'
    assert is_logged_in?
    assert_not flash.blank?
  end

  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
  end
end
