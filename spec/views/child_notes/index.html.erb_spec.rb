require 'rails_helper'

RSpec.describe "child_notes/index", type: :view do
  before(:each) do
    assign(:child_notes, [
      ChildNote.create!(
        :child_id => 2,
        :title => "Title",
        :text => "MyText"
      ),
      ChildNote.create!(
        :child_id => 2,
        :title => "Title",
        :text => "MyText"
      )
    ])
  end

  it "renders a list of child_notes" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
