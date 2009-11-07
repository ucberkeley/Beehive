require 'spec_helper'

describe "/pictures/index.html.erb" do
  include PicturesHelper

  before(:each) do
    assigns[:pictures] = [
      stub_model(Picture,
        :url => "value for url",
        :user => 1,
        :job => 1
      ),
      stub_model(Picture,
        :url => "value for url",
        :user => 1,
        :job => 1
      )
    ]
  end

  it "renders a list of pictures" do
    render
    response.should have_tag("tr>td", "value for url".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
