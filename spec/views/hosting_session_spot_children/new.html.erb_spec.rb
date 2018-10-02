require 'rails_helper'

RSpec.describe "hosting_session_spot_children/new", type: :view do
  before(:each) do
    assign(:hosting_session_spot_child, HostingSessionSpotChild.new(
      :child_id => 1,
      :hosting_session_spot_id => 1
    ))
  end

  it "renders new hosting_session_spot_child form" do
    render

    assert_select "form[action=?][method=?]", hosting_session_spot_children_path, "post" do

      assert_select "input[name=?]", "hosting_session_spot_child[child_id]"

      assert_select "input[name=?]", "hosting_session_spot_child[hosting_session_spot_id]"
    end
  end
end
