require 'rails_helper'

RSpec.describe "sessions/index", type: :view do
  before(:each) do
    assign(:sessions, [
      Session.create!(
        :name => "Name",
        :public => false
      ),
      Session.create!(
        :name => "Name",
        :public => false
      )
    ])
  end

  it "renders a list of sessions" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
