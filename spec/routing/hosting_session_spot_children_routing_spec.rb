require "rails_helper"

RSpec.describe HostingSessionSpotChildrenController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/hosting_session_spot_children").to route_to("hosting_session_spot_children#index")
    end

    it "routes to #new" do
      expect(:get => "/hosting_session_spot_children/new").to route_to("hosting_session_spot_children#new")
    end

    it "routes to #show" do
      expect(:get => "/hosting_session_spot_children/1").to route_to("hosting_session_spot_children#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/hosting_session_spot_children/1/edit").to route_to("hosting_session_spot_children#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/hosting_session_spot_children").to route_to("hosting_session_spot_children#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/hosting_session_spot_children/1").to route_to("hosting_session_spot_children#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/hosting_session_spot_children/1").to route_to("hosting_session_spot_children#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/hosting_session_spot_children/1").to route_to("hosting_session_spot_children#destroy", :id => "1")
    end

  end
end
