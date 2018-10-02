require 'rails_helper'

RSpec.describe "spot_statuses/new", type: :view do
  before(:each) do
    assign(:spot_status, SpotStatus.new(
      :name => "MyString",
      :public => false
    ))
  end

  it "renders new spot_status form" do
    render

    assert_select "form[action=?][method=?]", spot_statuses_path, "post" do

      assert_select "input[name=?]", "spot_status[name]"

      assert_select "input[name=?]", "spot_status[public]"
    end
  end
end
