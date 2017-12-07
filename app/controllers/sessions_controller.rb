class SessionsController < ApplicationController
  before_action :guest_user, only: [:new, :create]
  before_action :signed_in_user, only: [:destroy]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      user.signed_in_at = DateTime.current
      user.save!(touch: false)
      sign_in user
      flash[:success] = 'You have successfully signed in. Welcome!'
      redirect_to overview_user_path(session[:user_username])
    else
      flash.now[:danger] = 'Yo ass goofed homie! Da email/password you provided is invalid!'
      render 'new'
    end
  end

  def destroy
    user = User.find(session[:user_id])
    sign_out
    flash[:success] = 'You have successfully signed out. Goodbye!'
    redirect_to root_url
  end
end
