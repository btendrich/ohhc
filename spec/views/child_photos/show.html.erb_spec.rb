require 'rails_helper'

RSpec.describe "child_photos/show", type: :view do
  before(:each) do
    @child_photo = assign(:child_photo, ChildPhoto.create!(
      :child_id => 2,
      :description => "Description",
      :key => "Key",
      :row_order => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Key/)
    expect(rendered).to match(/3/)
  end
end
