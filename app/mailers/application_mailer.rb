class ApplicationMailer < ActionMailer::Base
  default from: 'info@mydefaultemail.com'
  layout 'mailer'
end
