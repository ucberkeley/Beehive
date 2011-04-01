require 'spec_helper'

describe "attribs/new.html.erb" do
  before(:each) do
    assign(:attrib, stub_model(Attrib,
      :name => "MyString",
      :value => "MyString"
    ).as_new_record)
  end

  it "renders new attrib form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => attribs_path, :method => "post" do
      assert_select "input#attrib_name", :name => "attrib[name]"
      assert_select "input#attrib_value", :name => "attrib[value]"
    end
  end
end
