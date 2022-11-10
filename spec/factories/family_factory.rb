# frozen_string_literal: true

FactoryBot.define do
  factory :family do
    organization
    name { Faker::Name.name }
    address_1 { Faker::Address.street_address }
    address_2 { Faker::Address.secondary_address }
    city { "Coeur d'Alene" }
    state { "Idaho" }
    zip { "83815" }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    region
    license_date { Faker::Date.between(from: 2.years.ago, to: Time.zone.today) }
    status { :open }
    race { Family.races.keys.sample.to_sym }
    religion { Family.religions.keys.sample.to_sym }
    other_children_in_home { Faker::Boolean.boolean }
    spots_available { Faker::Number.digit }
    icwa { Faker::Boolean.boolean }
    dogs { Faker::Boolean.boolean }
    cats { Faker::Boolean.boolean }
    other_animals { Faker::Boolean.boolean }
    available_visit_transportation { Faker::Boolean.boolean }
    available_school_transportation { Faker::Boolean.boolean }
    available_counselor_transportation { Faker::Boolean.boolean }
    latitude { rand(47.677..47.777) }
    longitude { rand(-116.999..-116.777) }
    recreational_activities do
      Family.recreational_activities.sample(Faker::Number.between(from: 1, to: Family.recreational_activities.count))
    end
    skills { Family.skills.sample(Faker::Number.between(from: 1, to: Family.skills.count)) }
    experience_with_care do
      Family.experience_with_care.sample(Faker::Number.between(from: 1, to: Family.experience_with_care.count))
    end
    availability { Family.availabilities.sample(Faker::Number.between(from: 1, to: Family.availabilities.count)) }

    trait :with_exclusions do
      transient do
        exclusion_count { 2 }
      end

      after(:create) do |family, evaluator|
        create_list(:exclusion, evaluator.exclusion_count, family: family)
      end
    end
  end
end
