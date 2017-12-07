class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  include SessionsHelper

  def validate_page(page, total, per)
    page = page.to_s
    last = (total / per.to_f).ceil
    if page.match?(/\A\d+\z/)
      page = page.to_i
      if page < 1
        page = 1
      elsif page > last
        page = last
      end
    else
      page = 1
    end

    return page
  end

  private

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
