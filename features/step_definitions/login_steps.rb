Given /^I am logged in as "(.*)"$/ do |user|
  CASClient::Frameworks::Rails::Filter.fake(user)
  visit "/login"
end

When /^I log out$/ do
  begin
    visit "/logout"
  rescue Exception=>e
  end
  visit "/"
end
