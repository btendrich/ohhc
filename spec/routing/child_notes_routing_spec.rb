require "rails_helper"

RSpec.describe ChildNotesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/child_notes").to route_to("child_notes#index")
    end

    it "routes to #new" do
      expect(:get => "/child_notes/new").to route_to("child_notes#new")
    end

    it "routes to #show" do
      expect(:get => "/child_notes/1").to route_to("child_notes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/child_notes/1/edit").to route_to("child_notes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/child_notes").to route_to("child_notes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/child_notes/1").to route_to("child_notes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/child_notes/1").to route_to("child_notes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/child_notes/1").to route_to("child_notes#destroy", :id => "1")
    end

  end
end
