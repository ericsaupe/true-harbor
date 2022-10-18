# frozen_string_literal: true

class Exclusion < ApplicationRecord
  belongs_to :family

  enum :gender, [:boy, :girl, :any]
  enum :comparator, [:less_than, :greater_than]
end
