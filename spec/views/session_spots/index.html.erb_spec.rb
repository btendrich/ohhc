require 'rails_helper'

RSpec.describe "session_spots/index", type: :view do
  before(:each) do
    assign(:session_spots, [
      SessionSpot.create!(
        :child_id => 2,
        :hosting_session_id => 3,
        :status_id => 4,
        :scholarship => 5,
        :row_order => 6,
        :public_notes => "MyText",
        :private_notes => "MyText"
      ),
      SessionSpot.create!(
        :child_id => 2,
        :hosting_session_id => 3,
        :status_id => 4,
        :scholarship => 5,
        :row_order => 6,
        :public_notes => "MyText",
        :private_notes => "MyText"
      )
    ])
  end

  it "renders a list of session_spots" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
