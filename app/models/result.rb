# frozen_string_literal: true

class Result < ApplicationRecord
  belongs_to :search
  belongs_to :family

  before_save :calculate_score

  after_update_commit -> {
    broadcast_changes
  }

  EXCLUDED_CALCULATION_FIELDS = ["address_1", "address_2", "city", "state", "zip", "distance", "region_id"].freeze

  def broadcast_changes
    broadcast_replace_later_to(search, partial: "results/result_table_row")
  end

  def selected?
    state == "selected"
  end

  def declined?
    state == "declined"
  end

  def waiting?
    state == "waiting"
  end

  def excluded?
    search.excluded_family_ids.include?(id)
  end

  def calculate_score
    matching = 0
    total = 0
    search.query.each do |key, value|
      next if value.blank?
      next if EXCLUDED_CALCULATION_FIELDS.include?(key)

      if family[key].is_a?(Array)
        # Handle array values
        matches = family[key] & value
        matching += matches.count
        total += value.count
      elsif family[key].in?([true, false])
        # Handle boolean values
        bool_value = ActiveModel::Type::Boolean.new.cast(value)
        next unless bool_value

        matching += 1 if bool_value == family[key]
        total += 1
      elsif key == "spots_available"
        # Handle spots_available values
        matching += 1 if value.to_i <= family[key].to_i
        total += 1
      else
        # Handle all others
        matching += 1 if family[key] == value
        total += 1
      end
    end

    self.score = if total.zero?
      100 # If no criteria, then 100% match
    else
      ((matching / total.to_f) * 100).round
    end
  end

  def contacted
    family.update(last_contacted_at: Time.zone.now) && update(updated_at: Time.zone.now)
  end
end
