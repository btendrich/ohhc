require 'rails_helper'

RSpec.describe "children/edit", type: :view do
  before(:each) do
    @child = assign(:child, Child.create!(
      :name => "MyString",
      :country => "MyString",
      :size => "MyString",
      :age_range => "MyString",
      :gender => "MyString",
      :description => "MyText",
      :notes => "MyText"
    ))
  end

  it "renders the edit child form" do
    render

    assert_select "form[action=?][method=?]", child_path(@child), "post" do

      assert_select "input[name=?]", "child[name]"

      assert_select "input[name=?]", "child[country]"

      assert_select "input[name=?]", "child[size]"

      assert_select "input[name=?]", "child[age_range]"

      assert_select "input[name=?]", "child[gender]"

      assert_select "textarea[name=?]", "child[description]"

      assert_select "textarea[name=?]", "child[notes]"
    end
  end
end
