require 'rails_helper'

RSpec.describe "hosting_periods/show", type: :view do
  before(:each) do
    @hosting_period = assign(:hosting_period, HostingPeriod.create!(
      :name => "Name",
      :visible => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
  end
end
