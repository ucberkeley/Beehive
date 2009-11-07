require 'spec_helper'

describe "/reviews/show.html.erb" do
  include ReviewsHelper
  before(:each) do
    assigns[:review] = @review = stub_model(Review,
      :user => 1,
      :body => "value for body",
      :rating => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/value\ for\ body/)
    response.should have_text(/1/)
  end
end
