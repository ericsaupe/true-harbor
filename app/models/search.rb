# frozen_string_literal: true

class Search < ApplicationRecord
  include Organizable

  has_many :results, dependent: :destroy
  has_many :families, through: :results
  has_many :children, dependent: :destroy

  accepts_nested_attributes_for :children, allow_destroy: true, reject_if: :all_blank

  serialize :query, JSON

  after_save :calculate_results
  after_update_commit { broadcast_replace_later_to :searches_table, partial: "searches/search_table_row" }

  scope :not_completed, -> { where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }

  enum :category, { emergent: 0, planned_respite: 1 }

  def completed?
    completed_at.present?
  end

  def find_families
    results = Family.open.not_on_break
    query.each do |key, value|
      results = results.or(Family.where(key => value))
    end
    results
  end

  def calculate_results
    find_families.find_each do |family|
      Result.find_or_initialize_by(search: self, family: family).save!
    end
  end

  def results_without_exclusions
    results = self.results.includes(family: :exclusions)
    children.find_each do |child|
      # TODO: Genders here seem to be pulling from the wrong place and pluralizing seems to help. The genders filtered
      # here are for the child and not the exclusion. It may have something to do with changing the enum values but
      # the tests seem to confirm this to work as is.
      results = results.where.not(families: { id: Exclusion.where(family: families, gender: [:any, child.gender],
        comparator: :less_than, age: child.age..18).pluck(:family_id) })
      results = results.where.not(families: { id: Exclusion.where(family: families, gender: [:any, child.gender],
        comparator: :greater_than, age: 0..child.age).pluck(:family_id) })
    end
    results
  end

  def excluded_family_ids
    @excluded_family_ids ||= results.pluck(:id) - results_without_exclusions.pluck(:id)
  end
end
