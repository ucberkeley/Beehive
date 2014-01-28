When /^I upload a file with valid data$/ do
  attach_file('user_csv', File.join(RAILS_ROOT, 'features', 'user_csv_files', 'good_csv.csv'))
  click_button "Upload"
end

When /^I upload a file with bad data$/ do
  attach_file('user_csv', File.join(RAILS_ROOT, 'features', 'user_csv_files', 'bad_csv.csv'))
  click_button "Upload"
end
