require 'rails_helper'

RSpec.describe "hosting_sessions/show", type: :view do
  before(:each) do
    @hosting_session = assign(:hosting_session, HostingSession.create!(
      :name => "Name",
      :short_name => "Short Name",
      :public => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Short Name/)
    expect(rendered).to match(/false/)
  end
end
