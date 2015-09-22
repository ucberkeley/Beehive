class AdvertisingMailer < ApplicationMailer
  def execute
    # emails = User.all.collect(&:email).select{|email| email.present?}
    emails = [ENV["test_email_1"], ENV["test_email_2"]]
    emails.each do |a|
      mail :to => a, :subject => "Introducing Beehive 2.0!"
    end
  end
end
