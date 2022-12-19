# frozen_string_literal: true

FactoryBot.define do
  factory :school_district do
    organization
    name { Faker::Address.unique.street_name }
  end
end
