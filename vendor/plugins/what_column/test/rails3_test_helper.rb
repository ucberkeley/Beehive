def rails_root
  File.dirname(__FILE__) + '/rails3_root'
end

ENV['BUNDLE_GEMFILE'] = rails_root + '/Gemfile'
require "#{rails_root}/config/environment.rb"

# Load the testing framework
require 'rails/test_help'

# Run the migrations

ActiveRecord::Migration.verbose = true
ActiveRecord::Migrator.migrate("#{rails_root}/db/migrate")


