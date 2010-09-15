require 'spec_helper'

describe "/reviews/edit.html.erb" do
  include ReviewsHelper

  before(:each) do
    assigns[:review] = @review = stub_model(Review,
      :new_record? => false,
      :user => 1,
      :body => "value for body",
      :rating => 1
    )
  end
=begin
  it "renders the edit review form" do
    render

    response.should have_tag("form[action=#{review_path(@review)}][method=post]") do
      with_tag('input#review_user[name=?]', "review[user]")
      with_tag('textarea#review_body[name=?]', "review[body]")
      with_tag('input#review_rating[name=?]', "review[rating]")
    end
  end
=end
end
