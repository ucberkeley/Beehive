source 'http://rubygems.org'

ruby '2.2.3'
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
gem 'email_validator'

# Support for syck. Syck was removed from the ruby stdlib.
gem 'syck'

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano-passenger'

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
  gem 'annotate'
  gem 'byebug'
end

# Testing
group :test do
  gem 'autotest-rails'
  gem 'cucumber-rails', "~> 1.4.2"
  gem 'capybara'
  gem 'database_cleaner'
  gem 'simplecov'
end

# Rspec
group :test, :development do
  gem 'rspec-rails', '~>3.0'
  gem 'rspec', '~> 3.3'
  gem 'factory_girl_rails', "~> 4.0"
end

# UI
gem 'therubyracer'
gem 'uglifier'
gem 'sass-rails', '>= 3.2'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '~> 3.3.3'
gem 'bootstrap_form'
gem 'bootstrap-material-design'

gem 'jquery-datatables-rails', '~> 3.3.0'
gem 'will_paginate-bootstrap'
gem 'bootstrap-datepicker-rails'
<<<<<<< HEAD
gem 'momentjs-rails'
=======

>>>>>>> 0a2a4b49d0340c01fa12a90c9d06e53b88bd762d
