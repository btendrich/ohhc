require 'rails_helper'

RSpec.describe "SessionSpots", type: :request do
  describe "GET /session_spots" do
    it "works! (now write some real specs)" do
      get session_spots_path
      expect(response).to have_http_status(200)
    end
  end
end
