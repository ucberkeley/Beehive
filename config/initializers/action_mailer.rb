# Configure the Action Mailer.
settings_path = File.join Rails.root, 'config', 'smtp_settings'
begin
  require settings_path
  ResearchMatch::Application.configure do
    config.action_mailer.delivery_method = :test
    config.action_mailer.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => 'localhost',
      :user_name            => @@smtp_username,
      :password             => @@smtp_pw,
      :authentication       => 'plain',
      :enable_starttls_auto => true
    }
  end
rescue LoadError
  $stderr.puts "Warning: Could not load #{settings_path}.rb: see https://github.com/jonathank/ResearchMatch/wiki/Usage-Notes-(IMPORTANT)"
end

