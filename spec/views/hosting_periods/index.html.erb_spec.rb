require 'rails_helper'

RSpec.describe "hosting_periods/index", type: :view do
  before(:each) do
    assign(:hosting_periods, [
      HostingPeriod.create!(
        :name => "Name",
        :visible => false
      ),
      HostingPeriod.create!(
        :name => "Name",
        :visible => false
      )
    ])
  end

  it "renders a list of hosting_periods" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
