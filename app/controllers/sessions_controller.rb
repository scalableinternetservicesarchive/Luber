class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # need to fix pass required issue
      #user.logged_in_at = DateTime.now
      #user.save!(touch: false)
      user.touch(:logged_in_at)
      log_in user
      flash[:success] = 'You have successfully logged in'
      redirect_to controller: 'users', action: 'overview', id: user.id
    else
      flash.now[:danger] = 'Yo ass goofed hommie! Da email/password you provided is invalid!'
      render 'new'
    end
  end

  def destroy
    user = User.find(session[:user_id])
    log_out
    flash[:success] = 'You have successfully logged out'
    redirect_to root_url
  end
end
