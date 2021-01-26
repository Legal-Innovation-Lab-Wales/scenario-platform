require 'rails_helper'

RSpec.describe "organisations/index", type: :view do
  before(:each) do
    assign(:organisations, [
      Organisation.create!(
        name: "Name"
      ),
      Organisation.create!(
        name: "Name"
      )
    ])
  end

  it "renders a list of organisations" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
  end
end
