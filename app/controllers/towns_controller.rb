class TownsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_town, only: [:show, :edit, :update, :destroy]

  # GET /towns
  # GET /towns.json
  def index
    @towns = Town.all
  end

  # GET /towns/1
  # GET /towns/1.json
  def show
    @town = Town.find(params[:id])
    @users = User.where(town_id: params[:id])
    if @users.any?
      @pets = Pet.where(user_id: @users.first.id)
      @users.each do |f|
        @pets.merge!(f.pets.all)
      end
    end
  end

  # GET /towns/new
  def new
    @town = Town.new
  end

  # GET /towns/1/edit
  def edit
  end

  # POST /towns
  # POST /towns.json
  def create
    @town = Town.new(town_params)

    respond_to do |format|
      if @town.save
        format.html { redirect_to @town, notice: 'Town was successfully created.' }
        format.json { render :show, status: :created, location: @town }
      else
        format.html { render :new }
        format.json { render json: @town.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /towns/1
  # PATCH/PUT /towns/1.json
  def update
    respond_to do |format|
      if @town.update(town_params)
        format.html { redirect_to @town, notice: 'Town was successfully updated.' }
        format.json { render :show, status: :ok, location: @town }
      else
        format.html { render :edit }
        format.json { render json: @town.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /towns/1
  # DELETE /towns/1.json
  def destroy
    @town.destroy
    respond_to do |format|
      format.html { redirect_to towns_url, notice: 'Town was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_town
    @town = Town.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def town_params
    params.require(:town).permit(:x_coordinate, :gameplay_mechanic,  :y_coordinate, :user_id, :image_url, :name, :description, :north_id, :south_id, :east_id, :west_id, :sound_file_id)
  end
end
