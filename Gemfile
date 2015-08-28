source 'http://rubygems.org'

ruby '2.0.0'
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
gem 'rails', '~> 4'
gem 'pg'
# store sessions in db rather than in cookies
gem 'activerecord-session_store'
# deprecated, to remove, user.UserObserver is the only place we use this
gem 'rails-observers'
gem "haml-rails", "~> 0.9"

# web server
gem 'unicorn'

# pagination & tagging
gem "kaminari", "~> 0.15.1"
gem 'will_paginate', "~> 3.0.pre2"
gem 'acts-as-taggable-on'

# Emails
gem 'actionmailer-with-request', '~> 0.3'
gem 'exception_notification' , '~> 4'

# Security
gem 'authlogic'
gem 'rubycas-client', "~> 2.3.9", :require => ['casclient', 'casclient/frameworks/rails/filter']
gem 'ucb_ldap', "2.0.0.pre5"
gem 'omniauth'
gem 'omniauth-cas'
gem 'bcrypt'

# Misc
gem 'pothoven-attachment_fu'
gem 'nokogiri'

# Deploy with Capistrano
gem 'capistrano'

# Production-specific
group :production do
  gem 'rails_12factor'
end

# Development
group :development do
  gem 'yard'
  gem 'better_errors', "1.1.0"
  gem 'binding_of_caller'
  gem 'bullet'
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

# UI
gem 'therubyracer'
gem 'uglifier'
gem 'sass-rails', '>= 3.2'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '~> 3.3.3'
gem 'bootstrap_form'

################################################################################

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end