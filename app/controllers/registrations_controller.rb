class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create]

  private
    def check_captcha
      unless verify_recaptcha
        self.resource = resource_class.new sign_up_params
        resource.validate
        set_minimum_password_length
        render :new
      end
    end
end
