# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "administrate", github: "geniuskidkanyi/administrate", branch: "asset-fix"
gem "bootsnap", require: false
gem "cancancan"
gem "devise"
gem "factory_bot_rails"
gem "faker"
gem "geocoder"
gem "image_processing", "~> 1.2"
gem "importmap-rails"
gem "jbuilder"
gem "kaminari"
gem "meta-tags"
gem "omniauth"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.4"
gem "ransack"
gem "redis", "~> 4.0"
gem "rolify"
gem "sentry-rails"
gem "sentry-ruby"
gem "sidekiq"
gem "sprockets-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails", "~> 1.1.1"
gem "view_component"

group :development, :test do
  gem "byebug"
  gem "dotenv-rails"
  gem "rspec-rails", "~> 4.0.2"
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-shopify", require: false
end

group :development do
  gem "rack-mini-profiler"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "timecop"
  gem "webdrivers"
end
