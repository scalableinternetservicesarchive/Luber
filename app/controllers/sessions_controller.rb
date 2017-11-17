class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      user.touch(:logged_in_at)
      log_in user
      flash[:success] = 'You have successfully logged in.'
      redirect_to controller: 'users', action: 'overview', id: user.id
    else
      flash.now[:danger] = 'Yo ass goofed hommie! Da email/password you provided is invalid!'
      render 'new'
    end
  end

  def destroy
    user = User.find(session[:user_id])
    user.touch(:logged_out_at)
    log_out
    flash[:success] = 'You have been logged out.'
    redirect_to root_url
  end
end
