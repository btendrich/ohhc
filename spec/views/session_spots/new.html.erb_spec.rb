require 'rails_helper'

RSpec.describe "session_spots/new", type: :view do
  before(:each) do
    assign(:session_spot, SessionSpot.new(
      :child_id => 1,
      :hosting_session_id => 1,
      :spot_status_id => 1,
      :scholarship => 1,
      :row_order => 1,
      :public_notes => "MyText",
      :private_notes => "MyText"
    ))
  end

  it "renders new session_spot form" do
    render

    assert_select "form[action=?][method=?]", session_spots_path, "post" do

      assert_select "input[name=?]", "session_spot[child_id]"

      assert_select "input[name=?]", "session_spot[hosting_session_id]"

      assert_select "input[name=?]", "session_spot[spot_status_id]"

      assert_select "input[name=?]", "session_spot[scholarship]"

      assert_select "input[name=?]", "session_spot[row_order]"

      assert_select "textarea[name=?]", "session_spot[public_notes]"

      assert_select "textarea[name=?]", "session_spot[private_notes]"
    end
  end
end
