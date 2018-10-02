class SpotStatusesController < ApplicationController
  before_action :set_spot_status, only: [:show, :edit, :update, :destroy]

  # GET /spot_statuses
  def index
    @spot_statuses = SpotStatus.all
  end

  # GET /spot_statuses/1
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
  def create
    @spot_status = SpotStatus.new(spot_status_params)

    if @spot_status.save
      redirect_to @spot_status, notice: 'Spot status was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /spot_statuses/1
  def update
    if @spot_status.update(spot_status_params)
      redirect_to @spot_status, notice: 'Spot status was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /spot_statuses/1
  def destroy
    @spot_status.destroy
    redirect_to spot_statuses_url, notice: 'Spot status was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spot_status
      @spot_status = SpotStatus.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def spot_status_params
      params.require(:spot_status).permit(:name, :public)
    end
end
