class UsersController < ApplicationController
  before_action :guest_user, only: [:new, :create]
  before_action :signed_in_user, except: [:new, :create]
  before_action :correct_user, except: [:new, :create, :show, :overview]
  before_action :set_user, only: [:destroy, :cars, :history, :settings, :promote, :destroy_all_cars, :destroy_all_rentals]
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
    if @user.destroy
      respond_to do |format|
        flash[:success] = 'Account successfully deleted'
        format.html { redirect_to root_url }
      end
    else
      error_messages = ''
      @user.errors.full_messages.each do |msg|
        error_messages += msg
      end
      respond_to do |format|
        flash[:danger] = error_messages
        format.html { redirect_to settings_user_path(session[:user_username]) }
      end
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
    @total_rentals = Rental.where(['user_id = ? OR (renter_id = ? AND renter_visible = ?)', @user.id, @user.id, true]).count
    @per_page_count = 4
    params[:page] = validate_page(params[:page], @total_rentals, @per_page_count)
    @visible_renter_rentals_count = Rental.where(['renter_id = ? AND renter_visible = ?', @user.id, true]).count
    @rentals = Rental.where(['user_id = ? OR (renter_id = ? AND renter_visible = ?)', @user.id, @user.id, true]).paginate( page: params[:page], per_page: @per_page_count )
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
#%a, %d %b %YThu, 07 Dec 2017
  # PATCH /users/1/promote
  def promote
    @user.update_column(:admin, true)

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

  def destroy_all_cars
    car_count = 0
    Car.where(user_id: @user.id).each do |car|
      if !car.destroy
        car_count += 1
      end
    end
    if car_count == 0
      Log.create!(
        user_id: session[:user_id], 
        action: 2, 
        content: 'Deleted all of the cars from My Cars')

      flash[:success] = 'All cars successfully deleted'
      respond_to do |format|
        format.html {redirect_to cars_user_path(@user.username)}
        format.json {head :no_content}
      end
    else
      err_str = "You own #{car_count} "
      car_count == 1 ? err_str += 'car that is' : err_str += 'cars that are'
      err_str += ' used in other rentals. You must first delete these rentals before you can delete '
      car_count == 1 ? err_str += 'this car' : err_str += 'these cars'

      flash[:danger] = err_str
      respond_to do |format|
        format.html {redirect_to rentals_user_path(@user.username)}
        format.json {head :no_content}
      end
    end
  end

  def destroy_all_rentals
    in_progress_count = 0
    Rental.where(user_id: @user.id).each do |rental|
      if !rental.destroy
        in_progress_count += 1
      end
    end
    if in_progress_count == 0
      Log.create!(
        user_id: session[:user_id], 
        action: 2, 
        content: 'Deleted all of the rental posts as owner from My Rentals')

      flash[:success] = 'All rental posts as owner successfully deleted'
    else
      err_str = "You are the owner of #{in_progress_count} "
      in_progress_count == 1 ? err_str += 'rental' : err_str += 'rentals'
      err_str += ' currently in progress. You must wait for '
      in_progress_count == 1 ? err_str += 'it' : err_str += 'them'
      err_str += ' to complete before you can delete them (the rest have been deleted)'

      flash[:danger] = err_str
    end

    respond_to do |format|
      format.html {redirect_to rentals_user_path(@user.username)}
      format.json {head :no_content}
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :city, :state, :about, :meetup, :username, :email, :password, :password_confirmation)
  end

  # Use callbacks to share common setup or constraints between actions
  def set_user
    @user = User.find_by(username: params[:username])
  end

  # Confirms the correct user
  def correct_user
    set_user
    unless current_user?(@user)
      flash[:danger] = 'This action is not permitted for this account since you are not the owner'
      redirect_to overview_user_path(current_user)
    end
  end

  # Update the rental status to either 2 (In Progress) or 3 (Completed) based on time
  def set_progress
    set_user
    @rentals = Rental.where([
      '(renter_id = ? OR user_id = ?) AND ((status = ? AND start_time < ?) OR (status = ? AND end_time < ?))', 
      @user.id, @user.id, 1, DateTime.current, 2, DateTime.current])
    @rentals.each do |rental|
      if rental.end_time < DateTime.current
        rental.update_column(:status, 3)

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
        rental.update_column(:status, 2)
      end
    end
  end

  # Allow optional fields to stay nil instead of an empty string
  def new_val_check(new_val)
    new_val.blank? ? nil : new_val
  end

end