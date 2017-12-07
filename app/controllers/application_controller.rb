class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  include SessionsHelper

  private

  def validate_page(page, total, per)
    valid = false
    page = page.to_s
    last = (total / per.to_f).ceil
    
    if page.match?(/\A\d+\z/)
      page = page.to_i
      if page < 1
        page = 1
      elsif page > last
        page = last
      else
        valid = true
      end
    else
      page = 1
    end

    return page, valid
  end

  def validate_tag(tag)
    valid = false
    tag = tag.to_s
    
    if tag.match?(/\A^[a-z0-9-]+$\z/i) && tag.length > 2 && tag.length < 32
      valid = true
    else
      tag = 'invalid'
    end

    return tag, valid
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
