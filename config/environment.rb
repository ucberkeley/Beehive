# Load the rails application
require File.expand_path('../application', __FILE__)

require 'casclient' 
require 'casclient/frameworks/rails/filter'

# Initialize the rails application
ResearchMatch::Application.initialize!
