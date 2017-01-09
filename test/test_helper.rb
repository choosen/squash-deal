ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Test helper dumb description
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml 4 all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
