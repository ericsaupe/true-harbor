# frozen_string_literal: true

FactoryBot.define do
  factory :search do
    name { Faker::Name.name }
    query { { "city" => "Coeur d'Alene", "state" => "ID", "region" => "1", "zip" => "83815" } }
  end
end
