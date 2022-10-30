# frozen_string_literal: true

class Region < ApplicationRecord
  belongs_to :organization
  has_many :families, dependent: :restrict_with_error
end
