class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery

  protect_from_forgery with: :null_session
  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    # stored_location_for(resource) ||
  	inventory_notes_path
  end

  def not_found
    flash[:alert] = "Error 404: Page not found"
    redirect_to inventory_notes_path
  end

  protected

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
