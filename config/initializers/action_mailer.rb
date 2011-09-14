# Configure the Action Mailer.
settings_path = File.join Rails.root, 'config', 'smtp_settings'
begin
  require settings_path

  $smtp_username ||= ENV['SMTP_USERNAME']
  $smtp_password ||= ENV['SMTP_PASSWORD']

  ResearchMatch::Application.configure do
    ActionMailer::Base.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => 'researchmatch.heroku.com',
      :user_name            => $smtp_username,
      :password             => $smtp_pw,
      :authentication       => 'plain',
      :enable_starttls_auto => true
    }
  end
rescue LoadError
  $stderr.puts "Warning: Could not load #{settings_path}.rb: see https://github.com/jonathank/ResearchMatch/wiki/Usage-Notes-(IMPORTANT)"
end

