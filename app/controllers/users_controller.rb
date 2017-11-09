class UsersController < ApplicationController
  def show
    redirect_to overview_user_path, status: 301
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

  def edit
    @user = User.find(params[:id])
  end

  def overview
    @user = User.find(params[:id])
    @rides_sold = Rental.where(owner_id: @user.id)
    @rides_bought = Rental.where(renter_id: @user.id)
  end

  def rentals
    @user = User.find(params[:id])
    @rides_sold = Rental.where(owner_id: @user.id)
    @rides_bought = Rental.where(renter_id: @user.id)
  end

  def cars
    @user = User.find(params[:id])
    @cars = Car.where(user_id: @user.id)
  end

  def history
    @user = User.find(params[:id])
    @cars = Car.where(user_id: @user.id)
    @rides_sold = Rental.where(owner_id: @user.id)
    @rides_bought = Rental.where(renter_id: @user.id)
  end

  def settings
    @user = User.find(params[:id])
    @cars = Car.where(user_id: @user.id)
    @rides_sold = Rental.where(owner_id: @user.id)
    @rides_bought = Rental.where(renter_id: @user.id)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
