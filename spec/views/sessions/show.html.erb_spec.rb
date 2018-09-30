require 'rails_helper'

RSpec.describe "sessions/show", type: :view do
  before(:each) do
    @session = assign(:session, Session.create!(
      :name => "Name",
      :public => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
  end
end
