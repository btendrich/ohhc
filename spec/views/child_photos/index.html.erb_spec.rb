require 'rails_helper'

RSpec.describe "child_photos/index", type: :view do
  before(:each) do
    assign(:child_photos, [
      ChildPhoto.create!(
        :child_id => 2,
        :description => "Description",
        :key => "Key",
        :row_order => 3
      ),
      ChildPhoto.create!(
        :child_id => 2,
        :description => "Description",
        :key => "Key",
        :row_order => 3
      )
    ])
  end

  it "renders a list of child_photos" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Key".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
