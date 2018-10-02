require 'rails_helper'

RSpec.describe "child_notes/show", type: :view do
  before(:each) do
    @child_note = assign(:child_note, ChildNote.create!(
      :child_id => 2,
      :title => "Title",
      :text => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
