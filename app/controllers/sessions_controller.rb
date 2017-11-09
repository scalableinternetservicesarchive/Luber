class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log in and redirect to profile
      log_in user
      redirect_to user
      # redirect_to overview_user_path, params: { id => user.id }
      # redirect_to :action=>"overview", :controller=>"users", :user_id => user.id 
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
