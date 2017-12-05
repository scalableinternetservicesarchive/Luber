class CarsController < ApplicationController
  before_action :set_car, only: [:edit, :update, :destroy]
  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /cars/new
  def new
    @car = Car.new
  end

  # GET /cars/1/edit
  def edit
  end

  # POST /cars
  # POST /cars.json
  def create
    @car = Car.new(car_params)
    @car.user_id = session[:user_id]

    respond_to do |format|
      if @car.save
        Log.create!(
          user_id: session[:user_id], 
          action: 0, 
          content: 'Added a '+@car.color+', '+@car.year.to_s+' '+@car.make+' '+@car.model+' to My Cars')
        
        flash[:success] = 'Car successfully created'
        format.html { redirect_to cars_user_path(session[:user_username]) }
      else
        format.html {render :new}
        format.json {render json: @car.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /cars/1
  # PATCH/PUT /cars/1.json
  def update
    original_car = @car.dup
    original_car_tags = @car.all_tags.dup

    respond_to do |format|
      if @car.update(car_params)
        updates = []
        updates.push('Make') if original_car.make != @car.make
        updates.push('Model') if original_car.model != @car.model
        updates.push('Year') if original_car.year != @car.year
        updates.push('Color') if original_car.color != @car.color
        updates.push('License Plate') if original_car.license_plate != @car.license_plate
        updates.push('Tags') if original_car_tags != @car.all_tags

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
            content: 'Updated the '+update_str+' of the '+@car.make+' '+@car.model+' in My Cars')
        end

        flash[:success] = 'Car successfully updated'
        format.html { redirect_to cars_user_path(session[:user_username]) }
      else
        format.html {render :edit}
        format.json {render json: @car.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.json
  def destroy
    original_car = @car.dup

    if @car.destroy
      Log.create!(
        user_id: session[:user_id], 
        action: 2, 
        content: 'Deleted the '+original_car.color+', '+original_car.year.to_s+' '+original_car.make+' '+original_car.model+' from My Cars')

      respond_to do |format|
        flash[:success] = 'Car successfully deleted'
      end
    else
      error_messages = ''
      @car.errors.full_messages.each do |msg|
        error_messages += msg
      end
      flash[:danger] = error_messages
    end
    redirect_to cars_user_path(session[:user_username])
  end

  def tag_search
    if params[:tag]
      @cars = Car.tagged_with(params[:tag])
    else
      @cars = Car.all
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def car_params
    params.require(:car).permit(:user_id, :make, :model, :year, :color, :license_plate, :all_tags)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_car
    @car = Car.find(params[:id])
  end

  # before filters for authorization
  def signed_in_user
    unless signed_in?
      flash[:danger] = "Please sign in or register before messing with them cars."
      redirect_to signin_url
    end
  end

  # confirms the correct user
  def correct_user
    @car = Car.find(params[:id])
    @user = User.find(@car.user.id)
    unless current_user?(@user)
      flash[:danger] = "You are not the owner of this car! GTFO"
      redirect_to(@car)
    end
  end
end
