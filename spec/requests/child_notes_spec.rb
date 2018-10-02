require 'rails_helper'

RSpec.describe "ChildNotes", type: :request do
  describe "GET /child_notes" do
    it "works! (now write some real specs)" do
      get child_notes_path
      expect(response).to have_http_status(200)
    end
  end
end
