require 'spec_helper'

describe "applics/index.html.erb" do
  before(:each) do
    assign(:applics, [
      stub_model(Applic,
        :job => nil,
        :user => nil,
        :message => "MyText",
        :resume_id => 1,
        :transcript_id => 1
      ),
      stub_model(Applic,
        :job => nil,
        :user => nil,
        :message => "MyText",
        :resume_id => 1,
        :transcript_id => 1
      )
    ])
  end

  it "renders a list of applics" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
