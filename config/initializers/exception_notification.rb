# Set environment variable NOTIFIER_EMAIL=whatever@whatever.com
# Notifications will be sent from and to this email.

if (email=ENV['NOTIFIER_EMAIL']).blank?
  if Rails.env == 'production'
    Rails.logger.fatal "No exception notification email set."
    raise ArgumentError.new "No exception notification email set. See #{__FILE__}"
  end
else
  ResearchMatch::Application.config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix         => '[RM Notifier] ',
      :sender_address       => "ResearchMatch Notifier <#{email}>",
      :exception_recipients => email
    }
  # ExceptionNotifier::Notifier.prepend_view_path File.join(Rails.root, 'app', 'views')
end
