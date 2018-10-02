require 'rails_helper'

RSpec.describe "children/index", type: :view do
  before(:each) do
    assign(:children, [
      Child.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :identifier => "Identifier",
        :country => "Country",
        :gender => "Gender",
        :description => "MyText",
        :sibling_notes => "MyText",
        :orphanage => "Orphanage",
        :legal_status => "MyText"
      ),
      Child.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :identifier => "Identifier",
        :country => "Country",
        :gender => "Gender",
        :description => "MyText",
        :sibling_notes => "MyText",
        :orphanage => "Orphanage",
        :legal_status => "MyText"
      )
    ])
  end

  it "renders a list of children" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Identifier".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => "Gender".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Orphanage".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
