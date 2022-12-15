# frozen_string_literal: true

FactoryBot.define do
  factory :experience do
    association :experienceable, factory: :family
    child_need { association :child_need, organization: experienceable.organization }
  end
end
