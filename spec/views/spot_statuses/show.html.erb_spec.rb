require 'rails_helper'

RSpec.describe "spot_statuses/show", type: :view do
  before(:each) do
    @spot_status = assign(:spot_status, SpotStatus.create!(
      :name => "Name",
      :color => "Color"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Color/)
  end
end
