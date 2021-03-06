require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.

Bundler.require(*Rails.groups)

module Squashapp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Europe/Warsaw'
    config.active_record.default_timezone = :local # Or :utc

    config.generators do |g|
      g.test_framework :rspec, views: true, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
