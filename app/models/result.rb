# frozen_string_literal: true

class Result < ApplicationRecord
  belongs_to :search
  belongs_to :family

  before_save :calculate_score

  def calculate_score
    matching = 0
    total = 0
    search.query.each do |key, value|
      if family[key].is_a?(Array)
        matches = family[key] & value
        matching += matches.count
        total += value.count
      elsif family[key].in?([true, false])
        matching += 1 if ActiveModel::Type::Boolean.new.cast(value) == family[key]
        total += 1
      else
        matching += 1 if family[key] == value
        total += 1
      end
    end

    self.score = ((matching / total.to_f) * 100).round
  end
end
