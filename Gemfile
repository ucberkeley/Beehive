source 'http://rubygems.org'

# ruby '1.9.3'

# gem 'rails', '~> 4'
# 3.0.19 fixes security vulnerability CVE-2013-0156
# not tested with Rails >= 3.1

# adding pagination
gem "kaminari", "~> 0.15.1"

# Use unicorn web server
gem 'unicorn'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Debugging
gem 'exception_notification' , '3.0.1'

# Misc
gem 'pothoven-attachment_fu'
gem 'authlogic'
gem 'will_paginate', "~> 3.0.pre2"
gem 'rubycas-client', "~> 2.3.9", :require => ['casclient', 'casclient/frameworks/rails/filter']

gem 'ucb_ldap'
gem 'nokogiri'
gem 'actionmailer-with-request', '~> 0.3'
gem 'omniauth'
gem 'omniauth-cas'
gem 'bcrypt' 
gem 'acts_as_taggable_on_steroids'


# gem "jquery-rails", "~> 3.1.0"
# gem 'jquery-ui-rails', "~> 4.2.0"

# Deploy with Capistrano
gem 'capistrano'

# Production-specific
group :production do
  gem 'pg'
end

# Development
group :development do
  gem 'yard'
  gem "mysql2", "~> 0.3.11"
  gem 'better_errors', "1.1.0"
  gem 'binding_of_caller'
  gem "bullet"
end

# Testing
group :test do
  gem 'autotest-rails'
  gem 'rspec-rails'
  gem 'cucumber-rails', "~> 1.4.2"
  gem 'capybara'
  gem 'database_cleaner'
  gem 'simplecov'
end

################################################################################

# Use unicorn as the web server
# gem 'unicorn'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

gem 'therubyracer'
# gem 'coffee-rails', "~> 3.2.2"
gem 'uglifier'

gem 'sass-rails', '>= 3.2'
gem 'bootstrap-sass', '~> 3.3.3'