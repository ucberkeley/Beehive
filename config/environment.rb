ENV['RAILS_RELATIVE_URL_ROOT'] = "/research"

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ResearchMatch::Application.initialize!
