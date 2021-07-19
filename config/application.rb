require_relative 'boot'

require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "action_cable/engine"
require "action_mailbox/engine"
require "action_text/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Wreeto
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.action_view.field_error_proc = Proc.new { |html_tag, instance| "<span class='field error'>#{html_tag}</span>".html_safe }
    config.autoload_paths += %W(
      #{config.root}/app/services 
      #{config.root}/lib 
    )

    # Exception handling 400, 500
    config.load_defaults = '5.2.4.4'
    config.exceptions_app = self.routes
  end
end
