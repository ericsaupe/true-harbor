# frozen_string_literal: true

FactoryBot.define do
  factory :child_need do
    organization
    name { Faker::Lorem.unique.word.capitalize }
  end
end
