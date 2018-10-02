require "rails_helper"

RSpec.describe SpotStatusesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/spot_statuses").to route_to("spot_statuses#index")
    end

    it "routes to #new" do
      expect(:get => "/spot_statuses/new").to route_to("spot_statuses#new")
    end

    it "routes to #show" do
      expect(:get => "/spot_statuses/1").to route_to("spot_statuses#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/spot_statuses/1/edit").to route_to("spot_statuses#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/spot_statuses").to route_to("spot_statuses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/spot_statuses/1").to route_to("spot_statuses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/spot_statuses/1").to route_to("spot_statuses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/spot_statuses/1").to route_to("spot_statuses#destroy", :id => "1")
    end

  end
end
