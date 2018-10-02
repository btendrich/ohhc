require 'rails_helper'

RSpec.describe "hosting_session_spot_children/edit", type: :view do
  before(:each) do
    @hosting_session_spot_child = assign(:hosting_session_spot_child, HostingSessionSpotChild.create!(
      :child_id => 1,
      :hosting_session_spot_id => 1
    ))
  end

  it "renders the edit hosting_session_spot_child form" do
    render

    assert_select "form[action=?][method=?]", hosting_session_spot_child_path(@hosting_session_spot_child), "post" do

      assert_select "input[name=?]", "hosting_session_spot_child[child_id]"

      assert_select "input[name=?]", "hosting_session_spot_child[hosting_session_spot_id]"
    end
  end
end
