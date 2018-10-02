require 'rails_helper'

RSpec.describe "hosting_sessions/index", type: :view do
  before(:each) do
    assign(:hosting_sessions, [
      HostingSession.create!(
        :name => "Name",
        :public => false
      ),
      HostingSession.create!(
        :name => "Name",
        :public => false
      )
    ])
  end

  it "renders a list of hosting_sessions" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
