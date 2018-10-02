class HostingSessionSpotsController < ApplicationController
  before_action :set_hosting_session_spot, only: [:show, :edit, :update, :destroy]

  # GET /hosting_session_spots
  def index
    @hosting_session_spots = HostingSessionSpot.all
  end

  # GET /hosting_session_spots/1
  def show
  end

  # GET /hosting_session_spots/new
  def new
    @hosting_session_spot = HostingSessionSpot.new
  end

  # GET /hosting_session_spots/1/edit
  def edit
  end

  # POST /hosting_session_spots
  def create
    @hosting_session_spot = HostingSessionSpot.new(hosting_session_spot_params)

    if @hosting_session_spot.save
      redirect_to @hosting_session_spot, notice: 'Hosting session spot was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /hosting_session_spots/1
  def update
    if @hosting_session_spot.update(hosting_session_spot_params)
      redirect_to @hosting_session_spot, notice: 'Hosting session spot was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /hosting_session_spots/1
  def destroy
    @hosting_session_spot.destroy
    redirect_to hosting_session_spots_url, notice: 'Hosting session spot was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hosting_session_spot
      @hosting_session_spot = HostingSessionSpot.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def hosting_session_spot_params
      params.require(:hosting_session_spot).permit(:status_id, :hosting_session_id, :description, :scholarship, :family_id)
    end
end
