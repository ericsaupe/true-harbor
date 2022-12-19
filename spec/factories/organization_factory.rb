# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    subdomain { Faker::Internet.domain_word }

    after(:create) do |organization|
      organization_seeder = OrganizationSeeder.new(organization)
      organization_seeder.seed
    end
  end
end
