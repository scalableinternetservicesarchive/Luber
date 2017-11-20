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

      Log.create!(
        user_id: @user.id, 
        action: 0, 
        content: 'Created my Account (Welcome!)')

      log_in @user
      flash[:success] = 'Account successfully created. Welcome to Luber!'
      redirect_to controller: 'users', action: 'overview', id: @user.id
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    check_params = user_params
    check_params['first_name'] = new_val_check(check_params['first_name'])
    check_params['last_name'] = new_val_check(check_params['last_name'])
    check_params['city'] = new_val_check(check_params['city'])
    check_params['state'] = new_val_check(check_params['state'])

    original_user = @user.dup

    if @user.update(check_params)
      updates = []
      original_user.first_name == @user.first_name ? nil : updates.push('First Name')
      original_user.last_name == @user.last_name ? nil : updates.push('Last Name')
      original_user.city == @user.city ? nil : updates.push('City')
      original_user.state == @user.state ? nil : updates.push('State')
      original_user.username == @user.username ? nil : updates.push('Username')
      original_user.email == @user.email ? nil : updates.push('Email')
      original_user.password == @user.password ? nil : updates.push('Password')

      if updates.length() > 0
        update_str = ''
        if updates.length() == 1
          update_str = updates[0]
        elsif updates.length() == 2
          update_str = updates.join(' and ')
        else
          update_str = updates.take(updates.length() - 1).join(', ')+', and '+updates.last()
        end

        Log.create!(
          user_id: session[:user_id], 
          action: 1, 
          content: 'Updated the '+update_str+' of my Account')
      end

      flash[:success] = 'Account successfully updated'
      redirect_to overview_user_path(session[:user_id])
    else
      render 'edit'
    end
  end

  def overview
    @rides_sold = Rental.where(owner_id: @user.id)
    @rides_bought = Rental.where(['renter_id = ? AND renter_visible = ?', @user.id, true])
  end

  def rentals
    @rides_sold = Rental.where(owner_id: @user.id)
    @rides_bought = Rental.where(['renter_id = ? AND renter_visible = ?', @user.id, true])
  end

  def cars
    @cars = Car.where(user_id: @user.id)
  end

  def history
    @logs = Log.where(user_id: @user.id).order(updated_at: :desc).group_by_day(reverse: true){ |l| l.updated_at }
  end

  def settings
    @cars_count = Car.where(user_id: @user.id).length
    @rides_sold_count = Rental.where(owner_id: @user.id).length
    @rides_bought_count = Rental.where(renter_id: @user.id).length
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :city, :state, :username, :email, :password, :password_confirmation)
  end

  # Use callbacks to share common setup or constraints between actions
  def set_user
    @user = User.find(params[:id])
  end

  # Before filters for authorization
  def logged_in_user
    unless logged_in?
      flash[:danger] = 'Please login first'
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
      if rental.end_time < DateTime.now
        rental.update_attribute(:status, 3)

        car = Car.find(rental.car_id)
        owner_log = Log.create!(
          user_id: rental.owner_id, 
          action: 3, 
          content: 'Completed renting my '+car.make+' '+car.model+' starting on '+rental.start_time.strftime("%A, %b. %-d")+' to the renter ('+User.find(rental.renter_id).username+')')
        owner_log.touch(time: rental.end_time)
        
        renter_log = Log.create!(
          user_id: rental.renter_id, 
          action: 3, 
          content: 'Completed renting a '+car.make+' '+car.model+' starting on '+rental.start_time.strftime("%A, %b. %-d")+' from the owner ('+User.find(rental.owner_id).username+')')
        renter_log.touch(time: rental.end_time)
      else
        rental.update_attribute(:status, 2)
      end
    end
  end

  # Allow optional fields to stay nil instead of an empty string
  def new_val_check(new_val)
    new_val.blank? ? nil : new_val
  end

end