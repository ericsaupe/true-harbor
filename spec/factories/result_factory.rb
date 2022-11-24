# frozen_string_literal: true

FactoryBot.define do
  factory :result do
    search
    family { association :family, organization: search.organization }
    score { 0 }
    state { "default" }
  end
end
