class RentalsController < ApplicationController
  before_action :set_rental, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /rentals
  # GET /rentals.json
  def index
    @available_rentals = Rental.where(status: 0)
  end

  # GET /rentals/1
  # GET /rentals/1.json
  def show
    @rental = Rental.find(params[:id])
    @owner = User.find(@rental.owner_id)
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
      flash[:danger] = "You do not have any cars. Please add cars to your profile before creating a rental post."
      redirect_to rentals_url
    end
  end

  # GET /rentals/1/edit
  def edit
    @cars = Car.where(user_id: Rental.find(params[:id]).owner_id)
  end

  # POST /rentals
  # POST /rentals.json
  def create
    @rental = Rental.new(rental_params)

    respond_to do |format|
      if @rental.save
        format.html {redirect_to @rental, notice: 'Rental post was successfully created.'}
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
    respond_to do |format|
      if @rental.update(rental_params)
        format.html {redirect_to @rental, notice: 'Rental post was successfully updated.'}
        format.json {render :show, status: :ok, location: @rental}
      else
        format.html {render :edit}
        format.json {render json: @rental.errors, status: :unprocessable_entity}
      end
    end
  end

  def rent
    @rental = Rental.find(params[:id])
    @rental.update_attribute(:renter_id, session[:user_id])
    @rental.update_attribute(:status, 1)
    flash[:success] = 'You have successfully rented this car!'
    redirect_to @rental
  end

  def cancel
    @rental = Rental.find(params[:id])
    @rental.update_attribute(:renter_id, nil)
    @rental.update_attribute(:status, 4)
    flash[:success] = 'You have successfully cancelled renting this car.'
    redirect_to overview_user_path(session[:user_id])
  end

  # DELETE /rentals/1
  # DELETE /rentals/1.json
  def destroy
    @rental.destroy
    respond_to do |format|
      format.html {redirect_to rentals_url, notice: 'Rental post was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_rental
    @rental = Rental.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def rental_params
    params.require(:rental).permit(:owner_id, :renter_id, :car_id, :start_location, :end_location, :start_time, :end_time, :price, :terms)
  end

  # before filters for authorization
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in before accessing rental posts."
      redirect_to login_url
    end
  end

  # confirms the correct user
  def correct_user
    @rental = Rental.find(params[:id])
    @user = User.find(@rental.owner_id)
    unless current_user?(@user)
      flash[:danger] = "You are not the owner of this rental post."
      redirect_to(@rental)
    end
  end
end
