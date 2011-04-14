def rails_root
  File.dirname(__FILE__) + '/rails2_root'
end

require "#{rails_root}/config/environment.rb"

# Load the testing framework
require 'test_help'

# Run the migrations

ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate("#{rails_root}/db/migrate")

require 'shoulda'
require 'mocha'
