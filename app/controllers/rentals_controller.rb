class RentalsController < ApplicationController
  before_action :set_rental, only: [:rent, :cancel, :remove]
  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_progress, only: [:show]

  # GET /rentals
  # GET /rentals.json
  def index
    
    @per_page_count = 8
    @available_rentals = Rental.where(status: 0).paginate( page: params[:page], per_page: @per_page_count )
    @owners, @cars = [], []
    @available_rentals.each do |rental|
      @owners << User.find(rental.user_id)
      @cars << Car.find(rental.car_id)
    end
  end

  # GET /rentals/1
  # GET /rentals/1.json
  def show
    @owner = User.find(@rental.user_id)
    if @rental.renter_id
      @renter = User.find(@rental.renter_id)
    end
    @car = Car.find(@rental.car_id)
  end

  # GET /rentals/new
  def new
    @rental = Rental.new
    @cars = Car.where(user_id: session[:user_id])
    if @cars.blank?
      flash[:danger] = 'You do not have any cars. Please add cars to your profile before creating a rental post'
      redirect_to cars_user_path(session[:user_username])
    end
  end

  # GET /rentals/1/edit
  def edit
    @cars = Car.where(user_id: @rental.user_id)
  end

  # POST /rentals
  # POST /rentals.json
  def create
    @cars = Car.where(user_id: session[:user_id])
    @rental = Rental.new(rental_params)
    @rental.user_id = session[:user_id]

    respond_to do |format|
      if @rental.save
        car = Car.find(@rental.car_id)
        Log.create!(
          user_id: session[:user_id], 
          action: 0, 
          content: 'Added a post for my '+car.make+' '+car.model+' starting on '+@rental.start_time.strftime("%A, %b. %-d")+' to My Rentals')

        flash[:success] = 'Rental post successfully created'
        format.html {redirect_to @rental}
        format.json {render :show, status: :created, location: @rental}
      else
        format.html {render :new}
        format.json {render json: @rental.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /rentals/1
  # PATCH/PUT /rentals/1.json
  def update
    original_rental = @rental.dup
    car = Car.find(@rental.car_id)

    respond_to do |format|
      if @rental.update(rental_params)
        updates = []
        original_rental.car_id == @rental.car_id ? nil : updates.push('Car')
        original_rental.start_location == @rental.start_location ? nil : updates.push('Start Location')
        original_rental.end_location == @rental.end_location ? nil : updates.push('End Location')
        original_rental.start_time == @rental.start_time ? nil : updates.push('Start Time')
        original_rental.end_time == @rental.end_time ? nil : updates.push('End Time')
        original_rental.price == @rental.price ? nil : updates.push('Price')
        original_rental.terms == @rental.terms ? nil : updates.push('Terms')

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
            content: 'Updated the '+update_str+' of the post for my '+car.make+' '+car.model+' starting on '+@rental.start_time.strftime("%A, %b. %-d")+' in My Rentals')
        end

        flash[:success] = 'Rental post successfully updated'
        format.html {redirect_to @rental}
        format.json {render :show, status: :ok, location: @rental}
      else
        format.html {render :edit}
        format.json {render json: @rental.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH /rentals/1/rent
  def rent
    @rental.update_attribute(:renter_id, session[:user_id])
    @rental.update_attribute(:status, 1)

    car = Car.find(@rental.car_id)
    Log.create!(
      user_id: session[:user_id], 
      action: 0, 
      content: 'Rented a '+car.make+' '+car.model+' starting on '+@rental.start_time.strftime("%A, %b. %-d")+' from '+User.find(@rental.user_id).username)
    Log.create!(
      user_id: @rental.user_id, 
      action: 0, 
      content: 'My post for a '+car.make+' '+car.model+' starting on '+@rental.start_time.strftime("%A, %b. %-d")+' was rented by '+session[:user_username])

    flash[:success] = 'You have successfully rented this car'
    redirect_to @rental
  end

  # PATCH /rentals/1/cancel
  def cancel
    @rental.update_attribute(:status, 4)

    car = Car.find(@rental.car_id)
    if session[:user_id] == @rental.user_id
      if @rental.renter_id.nil?
        Log.create!(
          user_id: session[:user_id], 
          action: 4, 
          content: 'Canceled renting my '+car.make+' '+car.model+' starting on '+@rental.start_time.strftime("%A, %b. %-d"))
      else
        Log.create!(
          user_id: session[:user_id], 
          action: 4, 
          content: 'Canceled renting my '+car.make+' '+car.model+' starting on '+@rental.start_time.strftime("%A, %b. %-d")+' to the renter ('+User.find(@rental.renter_id).username+')')
        Log.create!(
          user_id: @rental.renter_id, 
          action: 4, 
          content: 'My rental for a '+car.make+' '+car.model+' starting on '+@rental.start_time.strftime("%A, %b. %-d")+' was canceled by the owner ('+session[:user_username]+')')
      end
    elsif session[:user_id] == @rental.renter_id
      Log.create!(
        user_id: session[:user_id], 
        action: 4, 
        content: 'Canceled renting a '+car.make+' '+car.model+' starting on '+@rental.start_time.strftime("%A, %b. %-d")+' from the owner ('+User.find(@rental.user_id).username+')')
      Log.create!(
        user_id: @rental.user_id, 
        action: 4, 
        content: 'My post for a '+car.make+' '+car.model+' starting on '+@rental.start_time.strftime("%A, %b. %-d")+' was canceled by the renter ('+session[:user_username]+')')
    end

    flash[:success] = 'You have successfully canceled renting this car'
    redirect_to @rental
  end

  # PATCH /rentals/1/remove
  def remove
    @rental.update_attribute(:renter_visible, false)

    car = Car.find(@rental.car_id)
    Log.create!(
      user_id: session[:user_id], 
      action: 2, 
      content: 'Removed the post for my rental of a '+car.make+' '+car.model+' starting on '+@rental.start_time.strftime("%A, %b. %-d")+' from '+User.find(@rental.user_id).username+' from My Rentals')

    flash[:success] = 'You have successfully removed this rental'
    action_name == 'rentals' ? (redirect_to rentals_user_path(session[:user_username])) : (redirect_to overview_user_path(session[:user_username]))
  end

  # DELETE /rentals/1
  # DELETE /rentals/1.json
  def destroy
    start_time = @rental.start_time.dup
    car = Car.find(@rental.car_id)

    @rental.destroy

    Log.create!(
      user_id: session[:user_id], 
      action: 2, 
      content: 'Deleted the post for my '+car.make+' '+car.model+' starting on '+start_time.strftime("%A, %b. %-d")+' from My Rentals')

    respond_to do |format|
      flash[:success] = 'Rental post successfully deleted'
      format.html {action_name == 'rentals' ? (redirect_to rentals_user_path(session[:user_username])) : (redirect_to overview_user_path(session[:user_username]))}
      format.json {head :no_content}
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through
  def rental_params
    params.require(:rental).permit(:car_id, :start_location, :end_location, :start_time, :end_time, :price, :terms)
  end

  # Use callbacks to share common setup or constraints between actions
  def set_rental
    @rental = Rental.find(params[:id])
  end

  # Before filters for authorization
  def signed_in_user
    unless signed_in?
      flash[:danger] = 'Please sign in before accessing rental posts'
      redirect_to signin_url
    end
  end

  # Confirms the correct user
  def correct_user
    @rental = Rental.find(params[:id])
    @user = User.find(@rental.user_id)
    unless current_user?(@user)
      flash[:danger] = 'You are not the owner of this rental post'
      redirect_to @rental
    end
  end

  # Update the rental status to either 2 (In Progress) or 3 (Completed) based on time
  def set_progress
    @rental = Rental.find(params[:id])
    if @rental.status == 1 || @rental.status == 2
      if @rental.end_time < DateTime.now
        @rental.update_attribute(:status, 3)

        car = Car.find(@rental.car_id)
        owner_log = Log.create!(
          user_id: @rental.user_id, 
          action: 3, 
          content: 'Completed renting my '+car.make+' '+car.model+' starting on '+@rental.start_time.strftime("%A, %b. %-d")+' to the renter ('+User.find(@rental.renter_id).username+')')
        owner_log.touch(time: @rental.end_time)

        renter_log = Log.create!(
          user_id: @rental.renter_id, 
          action: 3, 
          content: 'Completed renting a '+car.make+' '+car.model+' starting on '+@rental.start_time.strftime("%A, %b. %-d")+' from the owner ('+User.find(@rental.user_id).username+')')
        renter_log.touch(time: @rental.end_time)
      elsif @rental.status == 1 && @rental.start_time < DateTime.now
        @rental.update_attribute(:status, 2)
      end
    end
  end
end
