require 'rails_helper'

RSpec.describe "hosting_periods/new", type: :view do
  before(:each) do
    assign(:hosting_period, HostingPeriod.new(
      :name => "MyString",
      :visible => false
    ))
  end

  it "renders new hosting_period form" do
    render

    assert_select "form[action=?][method=?]", hosting_periods_path, "post" do

      assert_select "input[name=?]", "hosting_period[name]"

      assert_select "input[name=?]", "hosting_period[visible]"
    end
  end
end
