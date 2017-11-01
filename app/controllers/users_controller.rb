class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @my_cars = Car.where(user_id: @user.id)
    @rides_sold = RentalPost.where(owner_id: @user.id)
    @rides_bought = RentalPost.where(renter_id: @user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to Luber!'
      redirect_to @user
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
