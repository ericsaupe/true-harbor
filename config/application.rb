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

    if Rails.env.production? || ENV["SEND_EMAILS"]
      config.action_mailer.default_options = { from: "noreply@trueharbor.io" }
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = {
        address: "email-smtp.us-west-1.amazonaws.com",
        authentication: :plain,
        enable_starttls_auto: true,
        port: 587,
        user_name: Rails.application.credentials.dig(:aws, :ses, :smtp_username),
        password: Rails.application.credentials.dig(:aws, :ses, :smtp_password)
      }
    end

    config.active_job.queue_adapter = :sidekiq

    config.view_component.generate.sidecar = true
  end
end
