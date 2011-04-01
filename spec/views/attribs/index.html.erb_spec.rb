require 'spec_helper'

describe "attribs/index.html.erb" do
  before(:each) do
    assign(:attribs, [
      stub_model(Attrib,
        :name => "Name",
        :value => "Value"
      ),
      stub_model(Attrib,
        :name => "Name",
        :value => "Value"
      )
    ])
  end

  it "renders a list of attribs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Value".to_s, :count => 2
  end
end
