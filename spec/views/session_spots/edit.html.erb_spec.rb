require 'rails_helper'

RSpec.describe "session_spots/edit", type: :view do
  before(:each) do
    @session_spot = assign(:session_spot, SessionSpot.create!(
      :child_id => 1,
      :hosting_session_id => 1,
      :status_id => 1,
      :scholarship => 1,
      :row_order => 1,
      :public_notes => "MyText",
      :private_notes => "MyText"
    ))
  end

  it "renders the edit session_spot form" do
    render

    assert_select "form[action=?][method=?]", session_spot_path(@session_spot), "post" do

      assert_select "input[name=?]", "session_spot[child_id]"

      assert_select "input[name=?]", "session_spot[hosting_session_id]"

      assert_select "input[name=?]", "session_spot[status_id]"

      assert_select "input[name=?]", "session_spot[scholarship]"

      assert_select "input[name=?]", "session_spot[row_order]"

      assert_select "textarea[name=?]", "session_spot[public_notes]"

      assert_select "textarea[name=?]", "session_spot[private_notes]"
    end
  end
end
