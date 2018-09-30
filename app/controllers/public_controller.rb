class PublicController < ApplicationController
  def children
    @session = HostingSession.find(params[:id])
    @spots = SessionSpot.includes(:child).where(:hosting_session => @session).order('scholarship desc','children.country','spot_status_id','children.name')
  end

  def child
    @child = Child.find(params[:id])
    
    if @child.nil?
      flash[:notice] = "Can't locate child with id number #{params[:id]}"
      redirect_to '/public/children/1'
    end
  end
end
