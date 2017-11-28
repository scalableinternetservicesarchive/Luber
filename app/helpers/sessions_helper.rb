module SessionsHelper

  # logs in the given user
  def log_in(user)
    session[:user_id] = user.id
    session[:user_username] = user.username
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    session.delete(:user_username)
    @current_user = nil
  end

  def current_admin?
    if current_user
      return current_user.admin
    else
      return false
    end
  end

  def update_username?(user)
    session[:user_username] != user.username
  end
end
