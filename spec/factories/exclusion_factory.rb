# frozen_string_literal: true

FactoryBot.define do
  factory :exclusion do
    family
    gender { Exclusion.genders.keys.sample.to_sym }
    comparator { Exclusion.comparators.keys.sample.to_sym }
    age { Faker::Number.between(from: 0, to: 18) }
  end
end
