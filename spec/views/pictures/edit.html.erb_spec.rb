require 'spec_helper'

describe "/pictures/edit.html.erb" do
  include PicturesHelper

  before(:each) do
    assigns[:picture] = @picture = stub_model(Picture,
      :new_record? => false,
      :url => "value for url",
      :user => 1,
      :job => 1
    )
  end

  it "renders the edit picture form" do
    render

    response.should have_tag("form[action=#{picture_path(@picture)}][method=post]") do
      with_tag('input#picture_url[name=?]', "picture[url]")
      with_tag('input#picture_user[name=?]', "picture[user]")
      with_tag('input#picture_job[name=?]', "picture[job]")
    end
  end
end
