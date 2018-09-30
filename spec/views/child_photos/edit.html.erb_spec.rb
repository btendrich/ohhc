require 'rails_helper'

RSpec.describe "child_photos/edit", type: :view do
  before(:each) do
    @child_photo = assign(:child_photo, ChildPhoto.create!(
      :child_id => 1,
      :description => "MyString",
      :key => "MyString",
      :row_order => 1
    ))
  end

  it "renders the edit child_photo form" do
    render

    assert_select "form[action=?][method=?]", child_photo_path(@child_photo), "post" do

      assert_select "input[name=?]", "child_photo[child_id]"

      assert_select "input[name=?]", "child_photo[description]"

      assert_select "input[name=?]", "child_photo[key]"

      assert_select "input[name=?]", "child_photo[row_order]"
    end
  end
end
