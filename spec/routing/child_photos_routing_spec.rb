require "rails_helper"

RSpec.describe ChildPhotosController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/child_photos").to route_to("child_photos#index")
    end

    it "routes to #new" do
      expect(:get => "/child_photos/new").to route_to("child_photos#new")
    end

    it "routes to #show" do
      expect(:get => "/child_photos/1").to route_to("child_photos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/child_photos/1/edit").to route_to("child_photos#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/child_photos").to route_to("child_photos#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/child_photos/1").to route_to("child_photos#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/child_photos/1").to route_to("child_photos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/child_photos/1").to route_to("child_photos#destroy", :id => "1")
    end

  end
end
