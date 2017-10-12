class RentalpostsController < ApplicationController
  before_action :set_rentalpost, only: [:show, :edit, :update, :destroy]

  # GET /rentalposts
  # GET /rentalposts.json
  def index
    @rentalposts = Rentalpost.all
  end

  # GET /rentalposts/1
  # GET /rentalposts/1.json
  def show
  end

  # GET /rentalposts/new
  def new
    @rentalpost = Rentalpost.new
  end

  # GET /rentalposts/1/edit
  def edit
  end

  # POST /rentalposts
  # POST /rentalposts.json
  def create
    @rentalpost = Rentalpost.new(rentalpost_params)

    respond_to do |format|
      if @rentalpost.save
        format.html { redirect_to @rentalpost, notice: 'Rentalpost was successfully created.' }
        format.json { render :show, status: :created, location: @rentalpost }
      else
        format.html { render :new }
        format.json { render json: @rentalpost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rentalposts/1
  # PATCH/PUT /rentalposts/1.json
  def update
    respond_to do |format|
      if @rentalpost.update(rentalpost_params)
        format.html { redirect_to @rentalpost, notice: 'Rentalpost was successfully updated.' }
        format.json { render :show, status: :ok, location: @rentalpost }
      else
        format.html { render :edit }
        format.json { render json: @rentalpost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rentalposts/1
  # DELETE /rentalposts/1.json
  def destroy
    @rentalpost.destroy
    respond_to do |format|
      format.html { redirect_to rentalposts_url, notice: 'Rentalpost was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rentalpost
      @rentalpost = Rentalpost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rentalpost_params
      params.require(:rentalpost).permit(:content, :user_id)
    end
end
