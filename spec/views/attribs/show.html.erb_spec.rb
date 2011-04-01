require 'spec_helper'

describe "attribs/show.html.erb" do
  before(:each) do
    @attrib = assign(:attrib, stub_model(Attrib,
      :name => "Name",
      :value => "Value"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Value/)
  end
end
