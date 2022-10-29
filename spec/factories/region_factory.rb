# frozen_string_literal: true

FactoryBot.define do
  factory :region do
    organization
    name { Faker::Address.community }
  end
end
