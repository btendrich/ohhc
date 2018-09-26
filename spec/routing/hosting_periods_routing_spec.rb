require "rails_helper"

RSpec.describe HostingPeriodsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/hosting_periods").to route_to("hosting_periods#index")
    end

    it "routes to #new" do
      expect(:get => "/hosting_periods/new").to route_to("hosting_periods#new")
    end

    it "routes to #show" do
      expect(:get => "/hosting_periods/1").to route_to("hosting_periods#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/hosting_periods/1/edit").to route_to("hosting_periods#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/hosting_periods").to route_to("hosting_periods#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/hosting_periods/1").to route_to("hosting_periods#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/hosting_periods/1").to route_to("hosting_periods#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/hosting_periods/1").to route_to("hosting_periods#destroy", :id => "1")
    end

  end
end
