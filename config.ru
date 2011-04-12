# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

ENV['RAILS_RELATIVE_URL_ROOT'] ||= '/research'
map ActionController::Base.config.relative_url_root || "/research" do
    run ResearchMatch::Application
end
