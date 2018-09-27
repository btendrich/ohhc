class SpotStatusesController < ApplicationController
  before_action :set_spot_status, only: [:show, :edit, :update, :destroy]

  # GET /spot_statuses
  # GET /spot_statuses.json
  def index
    @spot_statuses = SpotStatus.all
  end

  # GET /spot_statuses/1
  # GET /spot_statuses/1.json
  def show
  end

  # GET /spot_statuses/new
  def new
    @spot_status = SpotStatus.new
  end

  # GET /spot_statuses/1/edit
  def edit
  end

  # POST /spot_statuses
  # POST /spot_statuses.json
  def create
    @spot_status = SpotStatus.new(spot_status_params)

    respond_to do |format|
      if @spot_status.save
        format.html { redirect_to @spot_status, notice: 'Spot status was successfully created.' }
        format.json { render :show, status: :created, location: @spot_status }
      else
        format.html { render :new }
        format.json { render json: @spot_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spot_statuses/1
  # PATCH/PUT /spot_statuses/1.json
  def update
    respond_to do |format|
      if @spot_status.update(spot_status_params)
        format.html { redirect_to @spot_status, notice: 'Spot status was successfully updated.' }
        format.json { render :show, status: :ok, location: @spot_status }
      else
        format.html { render :edit }
        format.json { render json: @spot_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spot_statuses/1
  # DELETE /spot_statuses/1.json
  def destroy
    @spot_status.destroy
    respond_to do |format|
      format.html { redirect_to spot_statuses_url, notice: 'Spot status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spot_status
      @spot_status = SpotStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spot_status_params
      params.require(:spot_status).permit(:name, :color)
    end
end
