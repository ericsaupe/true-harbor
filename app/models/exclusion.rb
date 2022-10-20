# frozen_string_literal: true

class Exclusion < ApplicationRecord
  belongs_to :family

  enum :gender, [:boy, :girl, :any]
  enum :comparator, [:less_than, :greater_than]

  def display_text
    gender_text = gender == "any" ? "children" : gender.humanize.downcase.pluralize
    comparator_text = comparator == "less_than" ? "younger than" : "older than"
    "No #{gender_text} #{comparator_text} #{age} years old."
  end
end
