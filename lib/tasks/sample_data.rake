# frozen_string_literal: true

task generate_data: :environment do
  raise "This task is only for development" unless Rails.env.development? || ENV["FORCE_GENERATE_DATA"]

  # Create an organization
  organization = FactoryBot.create(:organization, name: "Demo Organization", subdomain: "demo")
  # Create users
  FactoryBot.create(:user, email: "admin@localhost", organization: organization)
  10.times do |i|
    FactoryBot.create(:user, email: "user#{i}@example.com", organization: organization)
  end
  # Create families
  FactoryBot.create_list(:family, 100, organization: organization)
  # Create searches
  FactoryBot.create_list(:search, 5, organization: organization)
end
