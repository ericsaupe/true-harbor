# frozen_string_literal: true

class Search < ApplicationRecord
  include Organizable

  has_many :results, dependent: :destroy
  has_many :families, through: :results
  has_many :children, dependent: :destroy

  accepts_nested_attributes_for :children, allow_destroy: true, reject_if: :all_blank

  serialize :query, JSON

  after_validation :geocode
  after_save :calculate_results
  after_save :remove_filtered_results
  after_update_commit { broadcast_replace_later_to :searches_table, partial: "searches/search_table_row" }

  scope :not_completed, -> { where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }

  enum :category, { imminent: 0, disruption: 1, step_down: 2, planned_move: 3, respite: 4 }

  geocoded_by :address

  HARD_FILTERS = ["region_id"].freeze

  def completed?
    completed_at.present?
  end

  def find_families
    results = organization.families.open.not_on_break
    # Soft filters to find a good range of families
    query.each do |key, value|
      next if HARD_FILTERS.include?(key) || value.blank?

      results = results.or(organization.families.where(key => value))
    end
    # Hard filters to reduce the number of records
    HARD_FILTERS.each do |filter|
      next if query[filter].blank?

      results = results.where(filter => query[filter])
    end
    # Geospatial filter
    results = results.near([latitude, longitude], query.dig("distance")) if query.dig("distance").present?
    results
  end

  def calculate_results
    find_families.find_each do |family|
      Result.find_or_create_by!(search: self, family: family)
    end
  end

  def remove_filtered_results
    results.where.not(family_id: find_families.pluck(:id)).destroy_all
  end

  def results_without_exclusions
    results = self.results.includes(family: :exclusions)
    children.find_each do |child|
      # TODO: Genders here seem to be pulling from the wrong place and pluralizing seems to help. The genders filtered
      # here are for the child and not the exclusion. It may have something to do with changing the enum values but
      # the tests seem to confirm this to work as is.
      results = results.where.not(families: { id: organization.exclusions.where(
        family: families, gender: [:any, child.gender], comparator: :less_than,
        age: child.age..18
      ).pluck(:family_id) })
      results = results.where.not(families: { id: organization.exclusions.where(
        family: families, gender: [:any, child.gender], comparator: :greater_than,
        age: 0..child.age
      ).pluck(:family_id) })
    end
    results
  end

  def excluded_family_ids
    @excluded_family_ids ||= results.pluck(:id) - results_without_exclusions.pluck(:id)
  end

  def address
    [
      query.dig("address_1"),
      query.dig("address_2"),
      query.dig("city"),
      query.dig("state"),
      query.dig("zip"),
    ].compact.join(", ")
  end
end
