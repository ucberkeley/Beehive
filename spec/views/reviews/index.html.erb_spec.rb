require 'spec_helper'

describe "/reviews/index.html.erb" do
  include ReviewsHelper

  before(:each) do
    assigns[:reviews] = [
      stub_model(Review,
        :user => 1,
        :body => "value for body",
        :rating => 1
      ),
      stub_model(Review,
        :user => 1,
        :body => "value for body",
        :rating => 1
      )
    ]
  end

  it "renders a list of reviews" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for body".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
