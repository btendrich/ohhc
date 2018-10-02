require 'rails_helper'

RSpec.describe "children/new", type: :view do
  before(:each) do
    assign(:child, Child.new(
      :first_name => "MyString",
      :last_name => "MyString",
      :identifier => "MyString",
      :country => "MyString",
      :gender => "MyString",
      :description => "MyText",
      :sibling_notes => "MyText",
      :orphanage => "MyString",
      :legal_status => "MyText"
    ))
  end

  it "renders new child form" do
    render

    assert_select "form[action=?][method=?]", children_path, "post" do

      assert_select "input[name=?]", "child[first_name]"

      assert_select "input[name=?]", "child[last_name]"

      assert_select "input[name=?]", "child[identifier]"

      assert_select "input[name=?]", "child[country]"

      assert_select "input[name=?]", "child[gender]"

      assert_select "textarea[name=?]", "child[description]"

      assert_select "textarea[name=?]", "child[sibling_notes]"

      assert_select "input[name=?]", "child[orphanage]"

      assert_select "textarea[name=?]", "child[legal_status]"
    end
  end
end
