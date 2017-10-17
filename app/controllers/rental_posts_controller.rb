class RentalPostsController < ApplicationController
  before_action :set_rental_post, only: [:show, :edit, :update, :destroy]

  # GET /rental_posts
  # GET /rental_posts.json
  def index
    @rental_posts = RentalPost.all
  end

  # GET /rental_posts/1
  # GET /rental_posts/1.json
  def show
  end

  # GET /rental_posts/new
  def new
    @rental_post = RentalPost.new
  end

  # GET /rental_posts/1/edit
  def edit
  end

  # POST /rental_posts
  # POST /rental_posts.json
  def create
    @rental_post = RentalPost.new(rental_post_params)

    respond_to do |format|
      if @rental_post.save
        format.html { redirect_to @rental_post, notice: 'Rental post was successfully created.' }
        format.json { render :show, status: :created, location: @rental_post }
      else
        format.html { render :new }
        format.json { render json: @rental_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rental_posts/1
  # PATCH/PUT /rental_posts/1.json
  def update
    respond_to do |format|
      if @rental_post.update(rental_post_params)
        format.html { redirect_to @rental_post, notice: 'Rental post was successfully updated.' }
        format.json { render :show, status: :ok, location: @rental_post }
      else
        format.html { render :edit }
        format.json { render json: @rental_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rental_posts/1
  # DELETE /rental_posts/1.json
  def destroy
    @rental_post.destroy
    respond_to do |format|
      format.html { redirect_to rental_posts_url, notice: 'Rental post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rental_post
      @rental_post = RentalPost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rental_post_params
      params.require(:rental_post).permit(:car, :owner, :renter, :start_loc, :end_loc, :start_time, :end_time, :cost)
    end
end
