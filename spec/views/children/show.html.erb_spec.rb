require 'rails_helper'

RSpec.describe "children/show", type: :view do
  before(:each) do
    @child = assign(:child, Child.create!(
      :first_name => "First Name",
      :last_name => "Last Name",
      :identifier => "Identifier",
      :country => "Country",
      :gender => "Gender",
      :description => "MyText",
      :sibling_notes => "MyText",
      :orphanage => "Orphanage",
      :legal_status => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Identifier/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/Gender/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Orphanage/)
    expect(rendered).to match(/MyText/)
  end
end
