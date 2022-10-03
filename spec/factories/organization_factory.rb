# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    subdomain { Faker::Internet.domain_word }
  end
end
