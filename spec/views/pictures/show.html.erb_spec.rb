require 'spec_helper'

describe "/pictures/show.html.erb" do
  include PicturesHelper
  before(:each) do
    assigns[:picture] = @picture = stub_model(Picture,
      :url => "value for url",
      :user => 1,
      :job => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ url/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
