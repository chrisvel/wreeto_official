ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'integration_test_helper'
require 'faker'
require 'mocha/minitest'

# Test Reporters settings
unless ENV['MINITEST_REPORTERS_ENABLED']=='no'
  require 'minitest/reporters'
  detailed_skip = ENV.fetch('MINITEST_REPORTER_DETAILED_SKIP', 'yes') == 'yes'
  Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new(detailed_skip: detailed_skip)
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end
