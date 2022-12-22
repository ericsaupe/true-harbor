# frozen_string_literal: true

namespace :true_harbor do
  task generate_data: :environment do
    raise "This task is only for development" unless Rails.env.development? || ENV["FORCE_GENERATE_DATA"]

    progress_bar = ProgressBar.create(total: 7)

    # Create an organization
    organization = Organization.find_by(subdomain: "demo") ||
      FactoryBot.create(:organization, name: "Demo Organization", subdomain: "demo")
    organization_seeder = OrganizationSeeder.new(organization)
    organization_seeder.seed
    progress_bar.increment
    # Create users
    if organization.users.find_by(email: "admin@example.com").nil?
      admin = FactoryBot.create(:user, email: "admin@example.com", organization: organization,
        confirmed_at: Time.current)
      admin.add_role(:admin)
    end
    if organization.users.find_by(email: "superadmin@example.com").nil? && !Rails.env.production?
      admin = FactoryBot.create(:user, email: "superadmin@example.com", organization: organization,
        confirmed_at: Time.current)
      admin.add_role(:super_admin)
    end
    10.times do |i|
      email = "user#{i}@example.com"
      next if organization.users.find_by(email: email)

      FactoryBot.create(:user, email: email, organization: organization)
    end
    progress_bar.increment
    # Create regions
    FactoryBot.create_list(:region, 5, organization: organization)
    progress_bar.increment
    # Create school districts
    FactoryBot.create_list(:school_district, 10, organization: organization)
    progress_bar.increment
    # Create families
    FactoryBot.create_list(:family, 100, :with_exclusions,
      region: organization.regions.order("RANDOM()").first,
      school_district: organization.school_districts.order("RANDOM()").first,
      organization: organization)
    progress_bar.increment
    # Randomize regions
    organization.families.find_each do |family|
      family.update!(
        region: organization.regions.order("RANDOM()").first,
        school_district: organization.school_districts.order("RANDOM()").first,
      )
    end
    progress_bar.increment
    # Create searches
    FactoryBot.create_list(:search, 5, :with_children, organization: organization)
    progress_bar.increment
  end
end
