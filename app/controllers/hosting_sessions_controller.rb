class HostingSessionsController < ApplicationController
  before_action :set_hosting_session, only: [:show, :edit, :update, :destroy]

  # GET /hosting_sessions
  # GET /hosting_sessions.json
  def index
    @hosting_sessions = HostingSession.all
  end

  # GET /hosting_sessions/1
  # GET /hosting_sessions/1.json
  def show
  end

  # GET /hosting_sessions/new
  def new
    @hosting_session = HostingSession.new
  end

  # GET /hosting_sessions/1/edit
  def edit
  end

  # POST /hosting_sessions
  # POST /hosting_sessions.json
  def create
    @hosting_session = HostingSession.new(hosting_session_params)

    respond_to do |format|
      if @hosting_session.save
        format.html { redirect_to @hosting_session, notice: 'Hosting session was successfully created.' }
        format.json { render :show, status: :created, location: @hosting_session }
      else
        format.html { render :new }
        format.json { render json: @hosting_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hosting_sessions/1
  # PATCH/PUT /hosting_sessions/1.json
  def update
    respond_to do |format|
      if @hosting_session.update(hosting_session_params)
        format.html { redirect_to @hosting_session, notice: 'Hosting session was successfully updated.' }
        format.json { render :show, status: :ok, location: @hosting_session }
      else
        format.html { render :edit }
        format.json { render json: @hosting_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hosting_sessions/1
  # DELETE /hosting_sessions/1.json
  def destroy
    @hosting_session.destroy
    respond_to do |format|
      format.html { redirect_to hosting_sessions_url, notice: 'Hosting session was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hosting_session
      @hosting_session = HostingSession.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hosting_session_params
      params.require(:hosting_session).permit(:name, :short_name, :begins, :public)
    end
end
