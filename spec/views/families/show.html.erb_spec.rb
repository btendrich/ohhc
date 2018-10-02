require 'rails_helper'

RSpec.describe "families/show", type: :view do
  before(:each) do
    @family = assign(:family, Family.create!(
      :first_names => "First Names",
      :last_name => "Last Name",
      :address => "Address",
      :city => "City",
      :state => "State",
      :zip => "Zip"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Names/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Zip/)
  end
end
