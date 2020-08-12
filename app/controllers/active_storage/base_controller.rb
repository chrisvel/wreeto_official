# frozen_string_literal: true

# The base controller for all ActiveStorage controllers.
class ActiveStorage::BaseController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  before_action do
    ActiveStorage::Current.host = request.base_url
  end
end