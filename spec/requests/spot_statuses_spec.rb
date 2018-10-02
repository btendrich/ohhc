require 'rails_helper'

RSpec.describe "SpotStatuses", type: :request do
  describe "GET /spot_statuses" do
    it "works! (now write some real specs)" do
      get spot_statuses_path
      expect(response).to have_http_status(200)
    end
  end
end
