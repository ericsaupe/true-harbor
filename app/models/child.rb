# frozen_string_literal: true

class Child < ApplicationRecord
  belongs_to :search

  enum :gender, [:boy, :girl, :other]
end
