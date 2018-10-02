require 'rails_helper'

RSpec.describe "child_notes/edit", type: :view do
  before(:each) do
    @child_note = assign(:child_note, ChildNote.create!(
      :child_id => 1,
      :title => "MyString",
      :text => "MyText"
    ))
  end

  it "renders the edit child_note form" do
    render

    assert_select "form[action=?][method=?]", child_note_path(@child_note), "post" do

      assert_select "input[name=?]", "child_note[child_id]"

      assert_select "input[name=?]", "child_note[title]"

      assert_select "textarea[name=?]", "child_note[text]"
    end
  end
end
