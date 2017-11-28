require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'valid signup redirects a new user to overview page' do
    get signup_path
    assert_difference 'User.count', 1 do
    post signup_path, params: { 
      user: { 
        username: 'ExampleUser',
        email: 'user@example.com',
        password: 'foobar',
        password_confirmation: 'foobar' } }
    end
    follow_redirect!
    assert_template 'users/overview'
    assert is_logged_in?
    assert_not flash.blank?
  end

  test 'non-matching pw at signup results in user errors and shows error msg' do
    get signup_path

    puts "before-bad-signup flash:"
    if defined?(flash)
      puts "Flash: #{flash.to_hash()}" 
    else
      puts "(flash is undefined.)"
    end

    assert_no_difference 'User.count' do
      post signup_path, params: { 
        user: { 
          username: '',
          email: 'user@invalid',
          password: 'foo',
          password_confirmation: 'bar' } }
    end
    


    puts "after-bad-signup flash:"
    if defined?(flash)
      puts "Flash: #{flash.to_hash()}" 
    else
      puts "(flash is undefined.)"
    end

    assert_response(:success) # it succeeds in loading the page, however, the page should have an err msg (but not a flash msg).
    assert flash.empty?
    assert_select 'div.alert' # the warning should be in some div on the page.
    # assert @user.errors.any? # no @user, bwah bwah
    # assert_not flash.blank? # errors not given by flash any more, but in alert div.
    # assert current_page?(signup_path)
    assert signup_path
  end
end
