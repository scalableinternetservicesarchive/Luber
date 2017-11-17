class UsersController < ApplicationController
  before_action :set_user, only: [:cars, :history, :settings]
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :set_progress, only: [:overview, :rentals]

  def show
    redirect_to overview_user_path, status: 301
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.touch(:logged_in_at)
      log_in @user
      flash[:success] = 'Welcome to Luber!'
      redirect_to controller: 'users', action: 'overview', id: @user.id
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
      flash[:success] = "Profile successfully updated"
      redirect_to controller: 'users', action: 'overview', id: @user.id
    else
      render 'edit'
    end
  end

  def overview
    @rides_sold = Rental.where(owner_id: @user.id)
    @rides_bought = Rental.where(renter_id: @user.id)
  end

  def rentals
    @rides_sold = Rental.where(owner_id: @user.id)
    @rides_bought = Rental.where(renter_id: @user.id)
  end

  def cars
    @cars = Car.where(user_id: @user.id)
  end

  def history
    @cars = Car.where(user_id: @user.id)
    @rides_sold = Rental.where(owner_id: @user.id)
    @rides_bought = Rental.where(renter_id: @user.id)
  end

  def settings
    @cars_count = Car.where(user_id: @user.id).length
    @rides_sold_count = Rental.where(owner_id: @user.id).length
    @rides_bought_count = Rental.where(renter_id: @user.id).length
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  # Use callbacks to share common setup or constraints between actions
  def set_user
    @user = User.find(params[:id])
  end

  # Before filters for authorization
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please login first."
      redirect_to login_path
    end
  end

  # Confirms the correct user
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  # Update the rental status to either 2 (In Progress) or 3 (Completed) based on time
  def set_progress
    @user = User.find(params[:id])
    @rentals = Rental.where([
      '(renter_id = ? OR owner_id = ?) AND ((status = ? AND start_time < ?) OR (status = ? AND end_time < ?))', 
      @user.id, @user.id, 1, DateTime.now, 2, DateTime.now])
    @rentals.each do |rental|
      rental.update_attribute(:status, rental.status + 1)
    end
  end

end
