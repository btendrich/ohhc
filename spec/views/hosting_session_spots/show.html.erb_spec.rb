require 'rails_helper'

RSpec.describe "hosting_session_spots/show", type: :view do
  before(:each) do
    @hosting_session_spot = assign(:hosting_session_spot, HostingSessionSpot.create!(
      :status_id => 2,
      :hosting_session_id => 3,
      :description => "MyText",
      :scholarship => 4,
      :family_id => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
  end
end
