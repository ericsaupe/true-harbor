domain = if Rails.env.production?
            ".trueharbor.io"
          else
            ".lvh.me"
          end
Rails.application.config.session_store :cookie_store, key: '_true_harbor_session', domain: domain, tld_length: 2
