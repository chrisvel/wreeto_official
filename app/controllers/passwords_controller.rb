class PasswordsController < Devise::PasswordsController
  prepend_before_action :check_captcha, only: [:create]

  private

  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new
      resource.validate # Look for any other validation errors besides Recaptcha
      respond_with_navigational(resource) { render :new }
    end
  end
end
