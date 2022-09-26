# frozen_string_literal: true

class Search < ApplicationRecord
  has_many :results, dependent: :destroy

  serialize :query, JSON

  after_save :calculate_results
  after_update_commit { broadcast_replace_later_to :searches_table, partial: "searches/search_table_row" }

  def find_families
    results = Family.open
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
end