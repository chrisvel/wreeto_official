class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :null_session
  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    # stored_location_for(resource) ||
  	notes_path
  end

  def not_found
    flash[:alert] = "Error 404: Page not found"
    redirect_to notes_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in,
      keys: [:username, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update,
      keys: [:username, :email, :password_confirmation, :current_password])
  end


  def layout_by_resource
    if devise_controller?
      if ["edit", "update"].include? action_name
        'application'
      else
        'empty'
      end
    else
      'application'
    end
  end
end
