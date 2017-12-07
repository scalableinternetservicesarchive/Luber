class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  include SessionsHelper

  private

  def valid_page?(page, total, per)
    valid = false
    last = (total / per.to_f).ceil
    
    if page.match(/\A\d+\z/)
      page = page.to_i
      if page < 1 || page > last
        message = 'The page you tried to jump to does not exist'
      else
        valid = true
      end
    else
      message = 'The page you tried to jump to contained invalid characters'
    end
    if !valid
      page = nil
    end

    return page, valid, message
  end

  # Confirms the user is a guest
  def guest_user
    if signed_in?
      flash[:danger] = 'Please sign out before accessing this page'
      redirect_to overview_user_path(current_user)
    end
  end

  # Confirms the user is signed in
  def signed_in_user
    unless signed_in?
      flash[:danger] = 'Please sign in before accessing this page'
      redirect_to signin_url
    end
  end
end
