class SignUpNotifyMailer < ApplicationMailer

  def user_signed_up
    admin_email = "admin@mydefaultemail.com"
    @user = params[:user]
    mail(to: admin_email, subject: "A new user has just signed up!")
  end

end
