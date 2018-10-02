require 'rails_helper'

RSpec.describe "HostingSessions", type: :request do
  describe "GET /hosting_sessions" do
    it "works! (now write some real specs)" do
      get hosting_sessions_path
      expect(response).to have_http_status(200)
    end
  end
end
