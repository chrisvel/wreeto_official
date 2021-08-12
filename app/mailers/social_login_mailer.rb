class SocialLoginMailer < ApplicationMailer
  
  def thank_you_sign_up
    @user = params[:user]
    mail(to: @user.email, subject: "Thank you for signing up to wreeto!")
  end
end
