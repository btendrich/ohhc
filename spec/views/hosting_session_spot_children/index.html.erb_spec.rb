require 'rails_helper'

RSpec.describe "hosting_session_spot_children/index", type: :view do
  before(:each) do
    assign(:hosting_session_spot_children, [
      HostingSessionSpotChild.create!(
        :child_id => 2,
        :hosting_session_spot_id => 3
      ),
      HostingSessionSpotChild.create!(
        :child_id => 2,
        :hosting_session_spot_id => 3
      )
    ])
  end

  it "renders a list of hosting_session_spot_children" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
