# frozen_string_literal: true

FactoryBot.define do
  factory :search do
    organization
    name { Faker::Name.name }
    query do
      {
        "city" => "Coeur d'Alene",
        "state" => "ID",
        "region" => "1",
        "zip" => "83815",
        "race" => Family.races.keys.sample.to_sym,
        "religion" => Family.religions.keys.sample.to_sym,
        "availability" => Family.availabilities.sample(Faker::Number.between(from: 1, to: Family.availabilities.count)),
        "other_children_in_home" => Faker::Boolean.boolean,
        "spots_available" => Faker::Number.digit,
        "icwa" => Faker::Boolean.boolean,
        "dogs" => Faker::Boolean.boolean,
        "cats" => Faker::Boolean.boolean,
        "other_animals" => Faker::Boolean.boolean,
        "available_visit_transportation" => Faker::Boolean.boolean,
        "available_school_transportation" => Faker::Boolean.boolean,
        "available_counselor_transportation" => Faker::Boolean.boolean,
        "recreational_activities" =>
          Family.recreational_activities.sample(Faker::Number.between(from: 1,
            to: Family.recreational_activities.count)),
        "skills" => Family.skills.sample(Faker::Number.between(from: 1, to: Family.skills.count)),
      }
    end

    after(:create) do |search|
      organization = search.organization
      limit = Faker::Number.between(from: 1, to: organization.child_needs.count)
      organization.child_needs.order("RANDOM()").limit(limit).find_each do |child_need|
        create(:experience, experienceable: search, child_need: child_need)
      end
    end

    trait :with_children do
      transient do
        child_count { 2 }
      end

      after(:create) do |search, evaluator|
        create_list(:child, evaluator.child_count, search: search)
      end
    end
  end
end
