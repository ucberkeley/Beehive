require 'spec_helper'

describe "/pictures/new.html.erb" do
  include PicturesHelper

  before(:each) do
    assigns[:picture] = stub_model(Picture,
      :new_record? => true,
      :url => "value for url",
      :user => 1,
      :job => 1
    )
  end

  it "renders new picture form" do
    render

    response.should have_tag("form[action=?][method=post]", pictures_path) do
      with_tag("input#picture_url[name=?]", "picture[url]")
      with_tag("input#picture_user[name=?]", "picture[user]")
      with_tag("input#picture_job[name=?]", "picture[job]")
    end
  end
end
