require 'rails_helper'

RSpec.describe "hosting_session_spots/new", type: :view do
  before(:each) do
    assign(:hosting_session_spot, HostingSessionSpot.new(
      :status_id => 1,
      :hosting_session_id => 1,
      :description => "MyText",
      :scholarship => 1,
      :family_id => 1
    ))
  end

  it "renders new hosting_session_spot form" do
    render

    assert_select "form[action=?][method=?]", hosting_session_spots_path, "post" do

      assert_select "input[name=?]", "hosting_session_spot[status_id]"

      assert_select "input[name=?]", "hosting_session_spot[hosting_session_id]"

      assert_select "textarea[name=?]", "hosting_session_spot[description]"

      assert_select "input[name=?]", "hosting_session_spot[scholarship]"

      assert_select "input[name=?]", "hosting_session_spot[family_id]"
    end
  end
end
