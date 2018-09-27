require 'rails_helper'

RSpec.describe "hosting_sessions/new", type: :view do
  before(:each) do
    assign(:hosting_session, HostingSession.new(
      :name => "MyString",
      :short_name => "MyString",
      :public => false
    ))
  end

  it "renders new hosting_session form" do
    render

    assert_select "form[action=?][method=?]", hosting_sessions_path, "post" do

      assert_select "input[name=?]", "hosting_session[name]"

      assert_select "input[name=?]", "hosting_session[short_name]"

      assert_select "input[name=?]", "hosting_session[public]"
    end
  end
end
