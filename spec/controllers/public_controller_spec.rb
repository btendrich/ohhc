require 'rails_helper'

RSpec.describe PublicController, type: :controller do

  describe "GET #children" do
    it "returns http success" do
      get :children
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #child" do
    it "returns http success" do
      get :child
      expect(response).to have_http_status(:success)
    end
  end

end
