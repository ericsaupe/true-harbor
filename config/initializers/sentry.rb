Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  config.traces_sampler = lambda do |sampling_context|
    # if this is the continuation of a trace, just use that decision (rate controlled by the caller)
    unless sampling_context[:parent_sampled].nil?
      next sampling_context[:parent_sampled]
    end

    # transaction_context is the transaction object in hash form
    # keep in mind that sampling happens right after the transaction is initialized
    # for example, at the beginning of the request
    transaction_context = sampling_context[:transaction_context]

    # transaction_context helps you sample transactions with more sophistication
    # for example, you can provide different sample rates based on the operation or name
    op = transaction_context[:op]
    transaction_name = transaction_context[:name]

    case op
    when /http/
      case transaction_name
      when /cable/
        0.0 # ignore all cable requests
      else
        0.1
      end
    else
      0.0 # ignore all other transactions
    end
  end

  config.enabled_environments = %w[production]
  config.excluded_exceptions += ["ActionController::RoutingError", "ActiveRecord::RecordNotFound", "Interrupt"]
end
