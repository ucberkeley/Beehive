what_column_path = File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << what_column_path

require 'what_column'
require 'what_column_migrator'

# Load the environment
ENV['RAILS_ENV'] ||= 'test'
ENV['RAILS_VERSION'] ||= '2.3.8'

if ENV['RAILS_VERSION'].to_s =~ /^2/
  require 'test/rails2_test_helper'
else
  require 'test/rails3_test_helper'
end