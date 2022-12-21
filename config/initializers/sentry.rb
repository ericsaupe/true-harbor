Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 0.25
  # or
  # config.traces_sampler = lambda do |context|
  #   true
  # end

  config.enabled_environments = %w[production]
  config.excluded_exceptions += ["ActionController::RoutingError", "ActiveRecord::RecordNotFound", "Interrupt"]
end
