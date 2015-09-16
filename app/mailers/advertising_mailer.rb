class AdvertisingMailer < ApplicationMailer
  default_url_options[:host] = ROOT_URL
  default :from => "Berkeley Beehive <beehive-support@lists.berkeley.edu>"

  def execute
    # mail(:to => User.all.collect(&:email), :subject => "Introducing Beehive 2.0!")
    test_array = [ENV["test_email_1"], ENV["test_email_2"]]
    mail(:to => test_array, :subject => "Introducing Beehive 2.0!")
  end
end
