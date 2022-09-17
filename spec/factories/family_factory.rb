# frozen_string_literal: true

FactoryBot.define do
  factory :family do
    name { Faker::Name.name }
    address_1 { Faker::Address.street_address }
    address_2 { Faker::Address.secondary_address }
    city { "Coeur d'Alene" }
    state { "ID" }
    zip { "83815" }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    region { "1" }
    license_date { Faker::Date.between(from: 2.years.ago, to: Time.zone.today) }
    status { :open }
    race { :white }
    religion { :other_religion }
    family_interest { :any }
    other_children_in_home { false }
    spots_available { 1 }
    icwa { false }
    dogs { false }
    cats { false }
    other_animals { false }
    available_visit_transportation { false }
    available_school_transportation { false }
    available_counselor_transportation { false }
    available_multiple_appointments_per_week { false }
    # recreational_activities { ["hiking", "camping"] }
    # skills { ["trauma training", "law enforcement"] }
    # experience_with_care { ["bipolar", "anxiety"] }

    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
