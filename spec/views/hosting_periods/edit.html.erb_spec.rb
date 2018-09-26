require 'rails_helper'

RSpec.describe "hosting_periods/edit", type: :view do
  before(:each) do
    @hosting_period = assign(:hosting_period, HostingPeriod.create!(
      :name => "MyString",
      :visible => false
    ))
  end

  it "renders the edit hosting_period form" do
    render

    assert_select "form[action=?][method=?]", hosting_period_path(@hosting_period), "post" do

      assert_select "input[name=?]", "hosting_period[name]"

      assert_select "input[name=?]", "hosting_period[visible]"
    end
  end
end
