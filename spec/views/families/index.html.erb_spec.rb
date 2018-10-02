require 'rails_helper'

RSpec.describe "families/index", type: :view do
  before(:each) do
    assign(:families, [
      Family.create!(
        :first_names => "First Names",
        :last_name => "Last Name",
        :address => "Address",
        :city => "City",
        :state => "State",
        :zip => "Zip"
      ),
      Family.create!(
        :first_names => "First Names",
        :last_name => "Last Name",
        :address => "Address",
        :city => "City",
        :state => "State",
        :zip => "Zip"
      )
    ])
  end

  it "renders a list of families" do
    render
    assert_select "tr>td", :text => "First Names".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Zip".to_s, :count => 2
  end
end
