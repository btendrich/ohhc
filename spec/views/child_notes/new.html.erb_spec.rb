require 'rails_helper'

RSpec.describe "child_notes/new", type: :view do
  before(:each) do
    assign(:child_note, ChildNote.new(
      :child_id => 1,
      :title => "MyString",
      :text => "MyText"
    ))
  end

  it "renders new child_note form" do
    render

    assert_select "form[action=?][method=?]", child_notes_path, "post" do

      assert_select "input[name=?]", "child_note[child_id]"

      assert_select "input[name=?]", "child_note[title]"

      assert_select "textarea[name=?]", "child_note[text]"
    end
  end
end
