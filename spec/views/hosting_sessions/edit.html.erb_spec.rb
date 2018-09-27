require 'rails_helper'

RSpec.describe "hosting_sessions/edit", type: :view do
  before(:each) do
    @hosting_session = assign(:hosting_session, HostingSession.create!(
      :name => "MyString",
      :short_name => "MyString",
      :public => false
    ))
  end

  it "renders the edit hosting_session form" do
    render

    assert_select "form[action=?][method=?]", hosting_session_path(@hosting_session), "post" do

      assert_select "input[name=?]", "hosting_session[name]"

      assert_select "input[name=?]", "hosting_session[short_name]"

      assert_select "input[name=?]", "hosting_session[public]"
    end
  end
end
