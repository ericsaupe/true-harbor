require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TrueHarbor
  class Application < Rails::Application
    config.load_defaults 7.0
    config.time_zone = "Pacific Time (US & Canada)"

    config.generators do |g|
      g.test_framework :rspec
      g.factory_bot suffix: "factory"
    end

    config.active_job.queue_adapter = :sidekiq

    config.view_component.generate.sidecar = true
  end
end
