# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    organization
    email { Faker::Internet.email }
    password { "test1234" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number }
    confirmed_at { Time.zone.now }

    factory :admin do
      after(:create) do |user, _evaluator|
        user.add_role(:admin)
      end
    end
  end
end
