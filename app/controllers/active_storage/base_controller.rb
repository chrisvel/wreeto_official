#
# https://github.com/rails/rails/blob/5-2-stable/activestorage/app/controllers/active_storage/base_controller.rb
#
class ActiveStorage::BaseController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  before_action do
    ActiveStorage::Current.host = request.base_url
  end
end