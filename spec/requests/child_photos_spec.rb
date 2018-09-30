require 'rails_helper'

RSpec.describe "ChildPhotos", type: :request do
  describe "GET /child_photos" do
    it "works! (now write some real specs)" do
      get child_photos_path
      expect(response).to have_http_status(200)
    end
  end
end
