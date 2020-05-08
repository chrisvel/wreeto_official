ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'integration_test_helper'
require 'minitest/reporters'

class ActiveSupport::TestCase
  fixtures :all
end
