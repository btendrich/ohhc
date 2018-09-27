require 'rails_helper'

RSpec.describe "children/show", type: :view do
  before(:each) do
    @child = assign(:child, Child.create!(
      :name => "Name",
      :country => "Country",
      :size => "Size",
      :age_range => "Age Range",
      :gender => "Gender",
      :description => "MyText",
      :notes => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/Size/)
    expect(rendered).to match(/Age Range/)
    expect(rendered).to match(/Gender/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
