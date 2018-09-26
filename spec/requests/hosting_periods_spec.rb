require 'rails_helper'

RSpec.describe "HostingPeriods", type: :request do
  describe "GET /hosting_periods" do
    it "works! (now write some real specs)" do
      get hosting_periods_path
      expect(response).to have_http_status(200)
    end
  end
end
