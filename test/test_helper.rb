ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  #returns true if a test user is logged in
  def is_logged_in?
    !session[:user_id].nil?
  end

  # log in as a particular user
  def log_in_as(user)
    puts "log_in_as (TestCase version): setting session to #{user.id}..."
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  # log in as a particular user
  def log_in_as(user, password: 'password')
    puts "log_in_as (Int test version): Logging in as #{user.email} with pw #{password}..."
    post login_path, params: { session: { email: user.email,
                                          password: password } }
  end
end
