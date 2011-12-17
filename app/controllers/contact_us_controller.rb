class ContactUsController < ApplicationController
  def contact
    if @current_user
      @user_email = @current_user.email
    else
      flash[:notice] = "You must be logged in to leave feedback"
      redirect_back_or home_path
    end
  end
  
  def send_email
    sender = params[:sender]
    subject = params[:subject]
    body = params[:body]
    mail = FeedbackMailer.send_feedback(sender, subject, body)
    mail.deliver
    flash[:notice] = "Your message has been sent. Thanks for your feedback!"
    redirect_to dashboard_path
  end
end
