class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

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
      redirect_to overview_user_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # handle successful update
      flash[:success] = "Profile updated"
      redirect_to overview_user_path
    else
      render 'edit'
    end
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
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  # before filters for authorization
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in first."
      redirect_to login_path
    end
  end

  # confirms the correct user
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

end
