require 'rails_helper'

RSpec.describe "organisations/new", type: :view do
  before(:each) do
    assign(:organisation, Organisation.new(
      name: "MyString"
    ))
  end

  it "renders new organisation form" do
    render

    assert_select "form[action=?][method=?]", organisations_path, "post" do

      assert_select "input[name=?]", "organisation[name]"
    end
  end
end
