# frozen_string_literal: true

FactoryBot.define do
  factory :child do
    search
    gender { Child.genders.keys.sample.to_sym }
    age { Faker::Number.between(from: 0, to: 18) }
  end
end
