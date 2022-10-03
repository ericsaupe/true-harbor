# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :families, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :searches, dependent: :destroy
  has_many :results, through: :searches
end
