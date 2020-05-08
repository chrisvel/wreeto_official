require "test_helper"
# require "capybara/rails"
# require 'capybara/minitest'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

module ActionDispatch
  class IntegrationTest
    include Rails.application.routes.url_helpers
    # include Capybara::DSL
    # include Capybara::Minitest::Assertions
    include Warden::Test::Helpers
    include Devise::Test::IntegrationHelpers
    Warden.test_mode!

    # def teardown
    #   Capybara.reset_sessions!
    #   Capybara.use_default_driver
    # end
  end
end
