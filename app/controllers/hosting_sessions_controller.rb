class HostingSessionsController < ApplicationController
  before_action :set_hosting_session, only: [:show, :edit, :update, :destroy]

  # GET /hosting_sessions
  def index
    @hosting_sessions = HostingSession.all
  end

  # GET /hosting_sessions/1
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
  def create
    @hosting_session = HostingSession.new(hosting_session_params)

    if @hosting_session.save
      redirect_to @hosting_session, notice: 'Hosting session was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /hosting_sessions/1
  def update
    if @hosting_session.update(hosting_session_params)
      redirect_to @hosting_session, notice: 'Hosting session was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /hosting_sessions/1
  def destroy
    @hosting_session.destroy
    redirect_to hosting_sessions_url, notice: 'Hosting session was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hosting_session
      @hosting_session = HostingSession.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def hosting_session_params
      params.require(:hosting_session).permit(:name, :date, :public)
    end
end
