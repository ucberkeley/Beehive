# Configure the Action Mailer.
settings_path = File.join Rails.root, 'config', 'smtp_settings'

$smtp_username ||= ENV['SMTP_USERNAME']
$smtp_password ||= ENV['SMTP_PASSWORD']

unless $smtp_username and $smtp_password
  begin
    require settings_path
  rescue LoadError
    $stderr.puts "Warning: Could not determine ActionMailer settings: see https://github.com/jonathank/ResearchMatch/wiki/Usage-Notes-(IMPORTANT)"
  end
end

ResearchMatch::Application.configure do
  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => $smtp_username,
    :user_name            => $smtp_username,
    :password             => $smtp_password,
    :authentication       => :plain,
    :enable_starttls_auto => true
  }
end

