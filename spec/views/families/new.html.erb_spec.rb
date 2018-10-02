require 'rails_helper'

RSpec.describe "families/new", type: :view do
  before(:each) do
    assign(:family, Family.new(
      :first_names => "MyString",
      :last_name => "MyString",
      :address => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zip => "MyString"
    ))
  end

  it "renders new family form" do
    render

    assert_select "form[action=?][method=?]", families_path, "post" do

      assert_select "input[name=?]", "family[first_names]"

      assert_select "input[name=?]", "family[last_name]"

      assert_select "input[name=?]", "family[address]"

      assert_select "input[name=?]", "family[city]"

      assert_select "input[name=?]", "family[state]"

      assert_select "input[name=?]", "family[zip]"
    end
  end
end
