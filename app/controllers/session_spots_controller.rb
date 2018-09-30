class SessionSpotsController < ApplicationController
  before_action :set_session_spot, only: [:show, :edit, :update, :destroy]

  # GET /session_spots
  # GET /session_spots.json
  def index
    @session_spots = SessionSpot.all
  end

  # GET /session_spots/1
  # GET /session_spots/1.json
  def show
  end

  # GET /session_spots/new
  def new
    @session_spot = SessionSpot.new
  end

  # GET /session_spots/1/edit
  def edit
  end

  # POST /session_spots
  # POST /session_spots.json
  def create
    @session_spot = SessionSpot.new(session_spot_params)

    respond_to do |format|
      if @session_spot.save
        format.html { redirect_to @session_spot, notice: 'Session spot was successfully created.' }
        format.json { render :show, status: :created, location: @session_spot }
      else
        format.html { render :new }
        format.json { render json: @session_spot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /session_spots/1
  # PATCH/PUT /session_spots/1.json
  def update
    respond_to do |format|
      if @session_spot.update(session_spot_params)
        format.html { redirect_to @session_spot, notice: 'Session spot was successfully updated.' }
        format.json { render :show, status: :ok, location: @session_spot }
      else
        format.html { render :edit }
        format.json { render json: @session_spot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /session_spots/1
  # DELETE /session_spots/1.json
  def destroy
    @session_spot.destroy
    respond_to do |format|
      format.html { redirect_to session_spots_url, notice: 'Session spot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session_spot
      @session_spot = SessionSpot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def session_spot_params
      params.require(:session_spot).permit(:child_id, :hosting_session_id, :spot_status_id, :scholarship, :row_order, :public_notes, :private_notes)
    end
end
