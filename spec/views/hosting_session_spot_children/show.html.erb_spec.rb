require 'rails_helper'

RSpec.describe "hosting_session_spot_children/show", type: :view do
  before(:each) do
    @hosting_session_spot_child = assign(:hosting_session_spot_child, HostingSessionSpotChild.create!(
      :child_id => 2,
      :hosting_session_spot_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
