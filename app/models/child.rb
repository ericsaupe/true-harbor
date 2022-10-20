# frozen_string_literal: true

class Child < ApplicationRecord
  belongs_to :search

  enum :gender, { boy: 0, girl: 1, other: 2 }
end
