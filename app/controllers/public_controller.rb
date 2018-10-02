class PublicController < ApplicationController
  def children
    @session = HostingSession.find(params[:id])
    @spots = HostingSessionSpot.where(:hosting_session => @session).order('scholarship desc','status_id')
  end

  def child
    @spot = HostingSessionSpot.find(params[:id])
    
    if @spot.nil?
      flash[:notice] = "Can't locate hosting spot with id number #{params[:id]}"
      redirect_to '/public/children/1'
    end
  end
end
