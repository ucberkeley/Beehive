require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

def default_user_options 
	{ :student_name => "joe", :student_email => "joe@berkeley.edu", :password => "abc123", :password_confirmation => "abc123", :is_faculty => false }
end

#
# User steps
#
def find_or_create_user(user_params={})
	user_params = user_params.merge default_user_options
  if @user=User.find(:first, :conditions => ["email = ?", user_params[:student_email]])
	log_in_user user_params.merge :email => user_params[:student_email]
	return @user
	end
  @user_params       ||= user_params
  post "/users", :user => user_params, :course => {:name => ""}, :category => {:name => ""}, :proglang => {:name => ""}
  @user = find_or_create_user(user_params)
#@user=User.find(:first, :conditions => ["email = ?", user_params[:email]])
end


Given /^I am logged in as "([^\"]*)"$/ do |name|
	find_or_create_user :student_name => name, :student_email => "#{name}@berkeley.edu"
end

Given /^I am an anonymous user$/ do
  log_out!
end

#
# URL stuff
# Basically, these differ from the premade ones by use of 'visiting'
# to differentiate between matching path_to(argument) and "argument".
#
When /^I visit (.+)$/ do |page_name|
  visit page_name
end

Then /^I should be visiting (.+)$/ do |page_name|
  URI.parse(current_url).path.should == page_name
end

#
# other stuff
#

Then "puts response" do
	puts response.body
end

Given /^there is a review for "([^\"]*)" from "([^\"]*)" with score 5$/ do |arg1, arg2|
  pending
end

Then /^I should see a menu with choices "([^\"]*)"$/ do |arg1|
  pending
end

Then /^I should go to the Reviews page for professor "([^\"]*)"$/ do |arg1|
  pending
end

Then /^I should see a form called "([^\"]*)"$/ do |arg1|
  pending
end

When /^I fill in the form with title "([^\"]*)"$/ do |arg1|
  pending
end

Then /^I should go to the Show page for the listing whose title is "([^\"]*)"$/ do |arg1|
  pending
end

When /^I fill in the textbox called "([^\"]*)" with "([^\"]*)"$/ do |arg1, arg2|
  pending
end

When /^I add a class "([^\"]*)" with grade "([^\"]*)"$/ do |arg1, arg2|
  pending
end

Given /^there is a research listing with title "([^\"]*)" with class "([^\"]*)" grade "([^\"]*)" tag "([^\"]*)"$/ do |arg1, arg2, arg3, arg4|
  pending
end

Given /^there is a research listing with title "([^\"]*)" with class "([^\"]*)" grade "([^\"]*)" class "([^\"]*)" grade "([^\"]*)" tag "([^\"]*)" tag "([^\"]*)"$/ do |arg1, arg2, arg3, arg4, arg5, arg6, arg7|
  pending
end

Given /^there is a user named "([^\"]*)" class "([^\"]*)" grade "([^\"]*)"$/ do |arg1, arg2, arg3|
  pending
end

Given /^there is a user named "([^\"]*)" class "([^\"]*)" grade "([^\"]*)" class "([^\"]*)" grade "([^\"]*)" class "([^\"]*)" grade "([^\"]*)"$/ do |arg1, arg2, arg3, arg4, arg5, arg6, arg7|
  pending
end

Then /^I should see "([^\"]*)" first$/ do |arg1|
  pending
end

Then /^I should see "([^\"]*)" 4th\t\#last because it doesn't have the java tag$/ do |arg1|
  pending
end

Given /^I am logged in$/ do
  pending
end

Given /^I fill in the form called "([^\"]*)"$/ do |arg1|
  pending
end

Given /^I press the button called "([^\"]*)"$/ do |arg1|
  pending
end

Then /^I should not see a button called "([^\"]*)"$/ do |arg1|
  pending
end

Then /^I should see a list of listings$/ do
  pending
end

Given /^I press "([^\"]*)" for the first listing in the list$/ do |arg1|
  pending
end

Then /^I should go to the Show page for that listing$/ do
  pending
end

Then /^I should see the "([^\"]*)" form$/ do |arg1|
  pending
end

Given /^there is an anonymous review for "([^\"]*)" from "([^\"]*)" with score 4$/ do |arg1, arg2|
  pending
end

Then /^I should see professor listing "([^\"]*)" with rating 4\.5$/ do |arg1|
  pending
end

When /^I click the button called "([^\"]*)"$/ do |arg1|
  pending
end

Then /^I should see a review from "([^\"]*)" with score 5$/ do |arg1|
  pending
end

Then /^I should see a review from "([^\"]*)" with score 4$/ do |arg1|
  pending
end