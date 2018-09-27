require 'rails_helper'

RSpec.describe "children/index", type: :view do
  before(:each) do
    assign(:children, [
      Child.create!(
        :name => "Name",
        :country => "Country",
        :size => "Size",
        :age_range => "Age Range",
        :gender => "Gender",
        :description => "MyText",
        :notes => "MyText"
      ),
      Child.create!(
        :name => "Name",
        :country => "Country",
        :size => "Size",
        :age_range => "Age Range",
        :gender => "Gender",
        :description => "MyText",
        :notes => "MyText"
      )
    ])
  end

  it "renders a list of children" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => "Size".to_s, :count => 2
    assert_select "tr>td", :text => "Age Range".to_s, :count => 2
    assert_select "tr>td", :text => "Gender".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
