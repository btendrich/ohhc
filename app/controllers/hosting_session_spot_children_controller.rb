class HostingSessionSpotChildrenController < ApplicationController
  before_action :set_hosting_session_spot_child, only: [:show, :edit, :update, :destroy]

  # GET /hosting_session_spot_children
  def index
    @hosting_session_spot_children = HostingSessionSpotChild.all
  end

  # GET /hosting_session_spot_children/1
  def show
  end

  # GET /hosting_session_spot_children/new
  def new
    @hosting_session_spot_child = HostingSessionSpotChild.new
  end

  # GET /hosting_session_spot_children/1/edit
  def edit
  end

  # POST /hosting_session_spot_children
  def create
    @hosting_session_spot_child = HostingSessionSpotChild.new(hosting_session_spot_child_params)

    if @hosting_session_spot_child.save
      redirect_to @hosting_session_spot_child, notice: 'Hosting session spot child was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /hosting_session_spot_children/1
  def update
    if @hosting_session_spot_child.update(hosting_session_spot_child_params)
      redirect_to @hosting_session_spot_child, notice: 'Hosting session spot child was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /hosting_session_spot_children/1
  def destroy
    @hosting_session_spot_child.destroy
    redirect_to hosting_session_spot_children_url, notice: 'Hosting session spot child was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hosting_session_spot_child
      @hosting_session_spot_child = HostingSessionSpotChild.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def hosting_session_spot_child_params
      params.require(:hosting_session_spot_child).permit(:child_id, :hosting_session_spot_id)
    end
end
