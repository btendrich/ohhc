require 'rails_helper'

RSpec.describe "spot_statuses/index", type: :view do
  before(:each) do
    assign(:spot_statuses, [
      SpotStatus.create!(
        :name => "Name",
        :color => "Color"
      ),
      SpotStatus.create!(
        :name => "Name",
        :color => "Color"
      )
    ])
  end

  it "renders a list of spot_statuses" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Color".to_s, :count => 2
  end
end
