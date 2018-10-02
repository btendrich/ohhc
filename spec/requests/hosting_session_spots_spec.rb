require 'rails_helper'

RSpec.describe "HostingSessionSpots", type: :request do
  describe "GET /hosting_session_spots" do
    it "works! (now write some real specs)" do
      get hosting_session_spots_path
      expect(response).to have_http_status(200)
    end
  end
end
