class ApplicationMailer < ActionMailer::Base
  default_url_options[:host] = ROOT_URL
  default :from => "Berkeley Beehive <beehive-support@lists.berkeley.edu>"
end
