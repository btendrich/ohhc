require 'rails_helper'

RSpec.describe "spot_statuses/edit", type: :view do
  before(:each) do
    @spot_status = assign(:spot_status, SpotStatus.create!(
      :name => "MyString",
      :color => "MyString"
    ))
  end

  it "renders the edit spot_status form" do
    render

    assert_select "form[action=?][method=?]", spot_status_path(@spot_status), "post" do

      assert_select "input[name=?]", "spot_status[name]"

      assert_select "input[name=?]", "spot_status[color]"
    end
  end
end
