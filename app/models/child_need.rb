# frozen_string_literal: true

class ChildNeed < ApplicationRecord
  belongs_to :organization
  has_many :experiences, dependent: :destroy
  has_many :families, through: :experiences, source: :experienceable, source_type: "Family"
  has_many :searches, through: :experiences, source: :experienceable, source_type: "Search"
end
