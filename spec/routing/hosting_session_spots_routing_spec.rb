require "rails_helper"

RSpec.describe HostingSessionSpotsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/hosting_session_spots").to route_to("hosting_session_spots#index")
    end

    it "routes to #new" do
      expect(:get => "/hosting_session_spots/new").to route_to("hosting_session_spots#new")
    end

    it "routes to #show" do
      expect(:get => "/hosting_session_spots/1").to route_to("hosting_session_spots#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/hosting_session_spots/1/edit").to route_to("hosting_session_spots#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/hosting_session_spots").to route_to("hosting_session_spots#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/hosting_session_spots/1").to route_to("hosting_session_spots#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/hosting_session_spots/1").to route_to("hosting_session_spots#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/hosting_session_spots/1").to route_to("hosting_session_spots#destroy", :id => "1")
    end

  end
end
