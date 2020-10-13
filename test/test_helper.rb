ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'integration_test_helper'
require 'minitest/reporters'

Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new(:color => true)]

class ActiveSupport::TestCase
  fixtures :all
end
