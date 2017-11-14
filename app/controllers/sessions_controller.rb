class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log in and redirect to profile
      log_in user
      flash[:success] = 'You have successfully logged in.'
      redirect_to controller: 'users', action: 'overview', id: user.id
    else
      # create an error message
      flash.now[:danger] = "Yo ass goofed hommie! Da email/password you provided is invalid!"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
    flash[:success] = 'You have been logged out.'
  end
end
