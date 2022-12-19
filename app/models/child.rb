# frozen_string_literal: true

class Child < ApplicationRecord
  belongs_to :search
  validates :gender, :age, presence: true

  enum :gender, { boy: 0, girl: 1, other: 2 }
end
