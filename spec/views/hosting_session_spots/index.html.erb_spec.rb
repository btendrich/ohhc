require 'rails_helper'

RSpec.describe "hosting_session_spots/index", type: :view do
  before(:each) do
    assign(:hosting_session_spots, [
      HostingSessionSpot.create!(
        :status_id => 2,
        :hosting_session_id => 3,
        :description => "MyText",
        :scholarship => 4,
        :family_id => 5
      ),
      HostingSessionSpot.create!(
        :status_id => 2,
        :hosting_session_id => 3,
        :description => "MyText",
        :scholarship => 4,
        :family_id => 5
      )
    ])
  end

  it "renders a list of hosting_session_spots" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
