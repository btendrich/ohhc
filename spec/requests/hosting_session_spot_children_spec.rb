require 'rails_helper'

RSpec.describe "HostingSessionSpotChildren", type: :request do
  describe "GET /hosting_session_spot_children" do
    it "works! (now write some real specs)" do
      get hosting_session_spot_children_path
      expect(response).to have_http_status(200)
    end
  end
end
