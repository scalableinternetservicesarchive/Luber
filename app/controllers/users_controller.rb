class UsersController < ApplicationController
  before_action :set_user, only: [:destroy, :cars, :history, :settings, :promote]
  before_action :signed_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_progress, only: [:overview, :rentals]

  def show
    redirect_to overview_user_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.touch(:signed_in_at)

      Log.create!(
        user_id: @user.id, 
        action: 0, 
        content: 'Created my Account (Welcome!)')

      sign_in @user
      flash[:success] = 'Account successfully created. Welcome to Luber!'
      redirect_to overview_user_path(session[:user_username])
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    mutable_params = user_params
    mutable_params.delete(:first_name) if mutable_params[:first_name].blank?
    mutable_params.delete(:last_name) if mutable_params[:last_name].blank?
    mutable_params.delete(:city) if mutable_params[:city].blank?
    mutable_params.delete(:state) if mutable_params[:state].blank?
    mutable_params.delete(:about) if mutable_params[:about].blank?
    mutable_params.delete(:meetup) if mutable_params[:meetup].blank?
    mutable_params.delete(:password) if mutable_params[:password].blank?
    mutable_params.delete(:password_confirmation) if mutable_params[:password_confirmation].blank?

    original_user = @user.dup

    if @user.update(mutable_params)
      updates = []
      updates.push('First Name') if original_user.first_name != @user.first_name
      updates.push('Last Name') if original_user.last_name != @user.last_name
      updates.push('City') if original_user.city != @user.city
      updates.push('State') if original_user.state != @user.state
      updates.push('About') if original_user.about != @user.about
      updates.push('Meetup Preferences') if original_user.meetup != @user.meetup
      updates.push('Username') if original_user.username != @user.username
      updates.push('Email') if original_user.email != @user.email
      updates.push('Password') if original_user.password != @user.password

      if updates.length() > 0
        update_str = ''
        if updates.length() == 1
          update_str = updates[0]
        elsif updates.length() == 2
          update_str = updates.join(' and ')
        else
          update_str = updates.take(updates.length() - 1).join(', ')+', and '+updates.last()
        end

        if update_username?(@user)
          session[:user_username] = @user.username
        end

        Log.create!(
          user_id: session[:user_id], 
          action: 1, 
          content: 'Updated the '+update_str+' of my Profile')
      end

      flash[:success] = 'Profile successfully updated'
      redirect_to overview_user_path(session[:user_username])
    else
      # Need to manually rollback if username length is 0 otherwise a UrlGeneration error occurs
      # since the edit url is based on the username and not the ID. I can't figure out why this is,
      # to see what I mean comment out these three lines and try updating with a blank username
      if @user.username.length == 0
        @user.username = original_user.username
      end
      render 'edit'
    end
  end

  def destroy
    @user.destroy

    respond_to do |format|
      flash[:success] = 'Account successfully deleted'
      format.html { redirect_to root_url }
    end
  end

  def overview
    @recent_owner_rentals = Rental.where(user_id: @user.id).limit(3)
    if @recent_owner_rentals.length > 0
      @or_owners, @or_renters, @or_cars = [], [], []
      @recent_owner_rentals.each do |rental|
        @or_owners << User.find(rental.user_id)
        rental.renter_id.nil? ? @or_renters << nil : @or_renters << User.find(rental.renter_id)
        @or_cars << Car.find(rental.car_id)
      end
    end
    @recent_renter_rentals = Rental.where(['renter_id = ? AND renter_visible = ?', @user.id, true]).limit(3)
    if @recent_renter_rentals.length > 0
      @rr_owners, @rr_renters, @rr_cars = [], [], []
      @recent_renter_rentals.each do |rental|
        @rr_owners << User.find(rental.user_id)
        @rr_renters << User.find(rental.renter_id)
        @rr_cars << Car.find(rental.car_id)
      end
    end
  end

  def rentals
    @total_rentals = Rental.where(['user_id = ? OR renter_id = ?', @user.id, @user.id]).count
    @per_page_count = 4
    params[:page] = validate_page(params[:page], @total_rentals, @per_page_count)
    @rentals = Rental.where(['user_id = ? OR renter_id = ?', @user.id, @user.id]).paginate( page: params[:page], per_page: @per_page_count )
    @owners, @renters, @cars = [], [], []
    @rentals.each do |rental|
      @owners << User.find(rental.user_id)
      rental.renter_id.nil? ? @renters << nil : @renters << User.find(rental.renter_id)
      @cars << Car.find(rental.car_id)
    end
  end

  def cars
    @total_cars = Car.where(user_id: @user.id).count
    @per_page_count = 4
    params[:page] = validate_page(params[:page], @total_cars, @per_page_count)
    @cars = Car.where(user_id: @user.id).paginate( page: params[:page], per_page: @per_page_count )
    @owners = []
    @cars.each do |car|
      @owners << User.find(car.user_id)
    end
  end

  def history
    @total_logs = Log.where(user_id: @user.id).count
    @per_page_count = 6
    params[:page] = validate_page(params[:page], @total_logs, @per_page_count)
    @page_logs = Log.where(user_id: @user.id).order(updated_at: :desc).paginate( page: params[:page], per_page: @per_page_count )
    @day_logs = @page_logs.group_by_day(reverse: true){ |l| l.updated_at }
  end

  def settings
  end

  # PATCH /users/1/promote
  def promote
    @user.update_attribute(:admin, true)

    Log.create!(
      user_id: session[:user_id], 
      action: 0, 
      content: 'Promoted '+@user.username+' to admin' )
    Log.create!(
      user_id: @user.id, 
      action: 0, 
      content: 'Promoted to admin by '+session[:user_username] )

    flash[:success] = 'You have successfully promoted this user to admin'
    redirect_to overview_user_path(@user.username)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :city, :state, :about, :meetup, :username, :email, :password, :password_confirmation)
  end

  # Use callbacks to share common setup or constraints between actions
  def set_user
    @user = User.find_by(username: params[:username])
  end

  # Before filters for authorization
  def signed_in_user
    unless signed_in?
      flash[:danger] = 'Please sign in first'
      redirect_to signin_path
    end
  end

  # Confirms the correct user
  def correct_user
    @user = User.find_by(username: params[:username])
    redirect_to(root_path) unless current_user?(@user)
  end

  # Update the rental status to either 2 (In Progress) or 3 (Completed) based on time
  def set_progress
    @user = User.find_by(username: params[:username])
    @rentals = Rental.where([
      '(renter_id = ? OR user_id = ?) AND ((status = ? AND start_time < ?) OR (status = ? AND end_time < ?))', 
      @user.id, @user.id, 1, DateTime.now, 2, DateTime.now])
    @rentals.each do |rental|
      if rental.end_time < DateTime.now
        rental.update_attribute(:status, 3)

        car = Car.find(rental.car_id)
        owner_log = Log.create!(
          user_id: rental.user_id, 
          action: 3, 
          content: 'Completed renting my '+car.make+' '+car.model+' starting on '+rental.start_time.strftime("%A, %b. %-d")+' to the renter ('+User.find(rental.renter_id).username+')')
        owner_log.touch(time: rental.end_time)
        
        renter_log = Log.create!(
          user_id: rental.renter_id, 
          action: 3, 
          content: 'Completed renting a '+car.make+' '+car.model+' starting on '+rental.start_time.strftime("%A, %b. %-d")+' from the owner ('+User.find(rental.user_id).username+')')
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