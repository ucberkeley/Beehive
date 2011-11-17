# Hook into Google Analytics

if ENV['ANALYTICS_ID'].present?
  ResearchMatch::Application.config.analytics = {
    :id => ENV['ANALYTICS_ID']
  }
else
  $stderr.puts "INFO: No ANALYTICS_ID property set." if Rails.env == 'production'
end
