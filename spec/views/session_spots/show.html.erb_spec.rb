require 'rails_helper'

RSpec.describe "session_spots/show", type: :view do
  before(:each) do
    @session_spot = assign(:session_spot, SessionSpot.create!(
      :child_id => 2,
      :hosting_session_id => 3,
      :status_id => 4,
      :scholarship => 5,
      :row_order => 6,
      :public_notes => "MyText",
      :private_notes => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
