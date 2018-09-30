require 'rails_helper'

RSpec.describe "child_photos/new", type: :view do
  before(:each) do
    assign(:child_photo, ChildPhoto.new(
      :child_id => 1,
      :description => "MyString",
      :key => "MyString",
      :row_order => 1
    ))
  end

  it "renders new child_photo form" do
    render

    assert_select "form[action=?][method=?]", child_photos_path, "post" do

      assert_select "input[name=?]", "child_photo[child_id]"

      assert_select "input[name=?]", "child_photo[description]"

      assert_select "input[name=?]", "child_photo[key]"

      assert_select "input[name=?]", "child_photo[row_order]"
    end
  end
end
