class CarsController < ApplicationController
  before_action :set_car, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :edit, :create, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def tag_search
    if params[:tag]
      @cars = Car.tagged_with(params[:tag])
    else
      @cars = Car.all
    end
  end

  # GET /cars/1
  # GET /cars/1.json
  def show
  end

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

    if session[:user_id]
      @car.user_id = session[:user_id]
    end

    respond_to do |format|
      if @car.save
        format.html {redirect_to @car, notice: 'Car was successfully created.'}
        format.json {render :show, status: :created, location: @car}
      else
        format.html {render :new}
        format.json {render json: @car.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /cars/1
  # PATCH/PUT /cars/1.json
  def update
    respond_to do |format|
      if @car.update(car_params)
        format.html {redirect_to @car, notice: 'Car was successfully updated.'}
        format.json {render :show, status: :ok, location: @car}
      else
        format.html {render :edit}
        format.json {render json: @car.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.json
  def destroy
    @car.destroy
    respond_to do |format|
      format.html do
        redirect_to controller: 'users', action: 'cars', id: current_user.id
        flash[:notice] = 'Car was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # before filters for authorization
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in or register before messing with them cars."
      redirect_to login_url
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
  
  # Use callbacks to share common setup or constraints between actions.
  def set_car
    @car = Car.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def car_params
    params.require(:car).permit(:user_id, :make, :plate_number, :model, :color, :year, :all_tags)
  end
end
