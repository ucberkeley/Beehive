source 'http://rubygems.org'

gem 'rails', '3.2.17' 
# gem 'rails', '~> 3.0.19'
# 3.0.19 fixes security vulnerability CVE-2013-0156
# not tested with Rails >= 3.1

# Use unicorn web server
gem 'unicorn'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Debugging
gem 'exception_notification'

# Performance optimization
# Bullet alerts N+1 query problems
gem "bullet", :group => "development"

# Misc
gem 'pothoven-attachment_fu'
gem 'authlogic',
    :git => 'git://github.com/binarylogic/authlogic.git'
gem 'will_paginate', "~> 3.0.pre2"
gem 'rubycas-client', "~> 2.3.9", :require => ['casclient', 'casclient/frameworks/rails/filter']

gem 'net-ldap', :require => 'net/ldap'
gem 'nokogiri'
gem 'actionmailer-with-request', '~> 0.3'
gem 'omniauth'
gem 'omniauth-cas'

gem "jquery-rails", "~> 3.1.0"
gem 'jquery-ui-rails', "~> 4.2.0"

# Deploy with Capistrano
gem 'capistrano'

# Heroku
gem 'heroku'

# Production-specific
group :production do
  gem 'pg'
end

# Development
group :development do
  gem 'yard'
  gem "mysql2", "~> 0.3.11"
end

# Testing
group :test do
  gem 'autotest-rails'
  gem 'rspec-rails'
  gem 'cucumber-rails'
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

group :assets do
  gem 'therubyracer'
  gem 'sass-rails', "  ~> 3.2.4"
  gem 'coffee-rails', "~> 3.2.2"
  gem 'uglifier'
end
