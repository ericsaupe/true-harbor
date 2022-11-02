# frozen_string_literal: true

task generate_data: :environment do
  raise "This task is only for development" unless Rails.env.development? || ENV["FORCE_GENERATE_DATA"]

  # Create an organization
  organization = Organization.find_by(subdomain: "demo") ||
    FactoryBot.create(:organization, name: "Demo Organization", subdomain: "demo")
  # Create users
  if organization.users.find_by(email: "admin@example.com").nil?
    admin = FactoryBot.create(:user, email: "admin@example.com", organization: organization)
    admin.add_role(:admin)
  end
  10.times do |i|
    email = "user#{i}@example.com"
    next if organization.users.find_by(email: email)

    FactoryBot.create(:user, email: email, organization: organization)
  end
  # Create regions
  FactoryBot.create_list(:region, 5, organization: organization)
  # Create families
  FactoryBot.create_list(:family, 100, :with_exclusions,
    region: organization.regions.sample, organization: organization)
  # Create searches
  FactoryBot.create_list(:search, 5, :with_children, organization: organization)
end
