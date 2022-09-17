# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "bootsnap", require: false
gem "devise"
gem "faker"
gem "image_processing", "~> 1.2"
gem "importmap-rails"
gem "jbuilder"
gem "omniauth"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.4"
gem "redis", "~> 4.0"
gem "sprockets-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails", "~> 1.1.1"
gem "view_component"

group :development, :test do
  gem "debug", platforms: [:mri, :mingw, :x64_mingw]
  gem "dotenv-rails"
  gem "factory_bot_rails"
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
  gem "webdrivers"
end
