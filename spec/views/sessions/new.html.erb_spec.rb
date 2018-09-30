require 'rails_helper'

RSpec.describe "sessions/new", type: :view do
  before(:each) do
    assign(:session, Session.new(
      :name => "MyString",
      :public => false
    ))
  end

  it "renders new session form" do
    render

    assert_select "form[action=?][method=?]", sessions_path, "post" do

      assert_select "input[name=?]", "session[name]"

      assert_select "input[name=?]", "session[public]"
    end
  end
end
