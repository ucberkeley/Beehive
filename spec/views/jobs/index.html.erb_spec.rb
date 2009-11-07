require 'spec_helper'

describe "/jobs/index.html.erb" do
  include JobsHelper

  before(:each) do
    assigns[:jobs] = [
      stub_model(Job,
        :user => 1,
        :title => "value for title",
        :desc => "value for desc",
        :category => 1,
        :num_positions => 1,
        :paid => false,
        :credit => false
      ),
      stub_model(Job,
        :user => 1,
        :title => "value for title",
        :desc => "value for desc",
        :category => 1,
        :num_positions => 1,
        :paid => false,
        :credit => false
      )
    ]
  end

  it "renders a list of jobs" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for desc".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", false.to_s, 2)
    response.should have_tag("tr>td", false.to_s, 2)
  end
end
