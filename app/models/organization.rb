# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :child_needs, dependent: :destroy
  has_many :families, dependent: :destroy
  has_many :exclusions, through: :families
  has_many :regions, dependent: :destroy
  has_many :searches, dependent: :destroy
  has_many :results, through: :searches
  has_many :school_districts, dependent: :destroy
  has_many :users, dependent: :destroy
end
