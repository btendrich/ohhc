class HostingPeriodsController < ApplicationController
  before_action :set_hosting_period, only: [:show, :edit, :update, :destroy]

  # GET /hosting_periods
  # GET /hosting_periods.json
  def index
    @hosting_periods = HostingPeriod.all
  end

  # GET /hosting_periods/1
  # GET /hosting_periods/1.json
  def show
  end

  # GET /hosting_periods/new
  def new
    @hosting_period = HostingPeriod.new
  end

  # GET /hosting_periods/1/edit
  def edit
  end

  # POST /hosting_periods
  # POST /hosting_periods.json
  def create
    @hosting_period = HostingPeriod.new(hosting_period_params)

    respond_to do |format|
      if @hosting_period.save
        format.html { redirect_to @hosting_period, notice: 'Hosting period was successfully created.' }
        format.json { render :show, status: :created, location: @hosting_period }
      else
        format.html { render :new }
        format.json { render json: @hosting_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hosting_periods/1
  # PATCH/PUT /hosting_periods/1.json
  def update
    respond_to do |format|
      if @hosting_period.update(hosting_period_params)
        format.html { redirect_to @hosting_period, notice: 'Hosting period was successfully updated.' }
        format.json { render :show, status: :ok, location: @hosting_period }
      else
        format.html { render :edit }
        format.json { render json: @hosting_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hosting_periods/1
  # DELETE /hosting_periods/1.json
  def destroy
    @hosting_period.destroy
    respond_to do |format|
      format.html { redirect_to hosting_periods_url, notice: 'Hosting period was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hosting_period
      @hosting_period = HostingPeriod.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hosting_period_params
      params.require(:hosting_period).permit(:name, :begins, :visible)
    end
end
