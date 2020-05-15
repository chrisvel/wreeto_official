require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Wreeto
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.action_view.field_error_proc = Proc.new { |html_tag, instance| "<span class='field error'>#{html_tag}</span>".html_safe }
    config.autoload_paths += %W(#{config.root}/app/services #{config.root}/lib)
  end
end
