require 'spec_helper'

describe "/jobs/edit.html.erb" do
  include JobsHelper

  before(:each) do
    assigns[:job] = @job = stub_model(Job,
      :new_record? => false,
      :user => 1,
      :title => "value for title",
      :desc => "value for desc",
      :category => 1,
      :num_positions => 1,
      :paid => false,
      :credit => false
    )
  end

  it "renders the edit job form" do
    #render

    #response.should have_tag("form[action=#{job_path(@job)}][method=post]") do
     # with_tag('input#job_user[name=?]', "job[user]")
     # with_tag('input#job_title[name=?]', "job[title]")
     # with_tag('textarea#job_desc[name=?]', "job[desc]")
     # with_tag('input#job_num_positions[name=?]', "job[num_positions]")
     # with_tag('input#job_paid[name=?]', "job[paid]")
     # with_tag('input#job_credit[name=?]', "job[credit]")
    #end
  end
end
