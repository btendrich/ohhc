require "rails_helper"

RSpec.describe HostingSessionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/hosting_sessions").to route_to("hosting_sessions#index")
    end

    it "routes to #new" do
      expect(:get => "/hosting_sessions/new").to route_to("hosting_sessions#new")
    end

    it "routes to #show" do
      expect(:get => "/hosting_sessions/1").to route_to("hosting_sessions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/hosting_sessions/1/edit").to route_to("hosting_sessions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/hosting_sessions").to route_to("hosting_sessions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/hosting_sessions/1").to route_to("hosting_sessions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/hosting_sessions/1").to route_to("hosting_sessions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/hosting_sessions/1").to route_to("hosting_sessions#destroy", :id => "1")
    end

  end
end
