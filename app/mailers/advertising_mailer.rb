class AdvertisingMailer < ApplicationMailer
  default_url_options[:host] = ROOT_URL
  default :from => "Berkeley Beehive <beehive-support@lists.berkeley.edu>"

  def execute
    # emails = User.all.collect(&:email)
    emails = [ENV["test_email_1"], ENV["test_email_2"]]
    emails.each do |a|
      mail :to => a, :subject => "Introducing Beehive 2.0!"
    end
  end
end
