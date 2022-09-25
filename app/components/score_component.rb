# frozen_string_literal: true

class ScoreComponent < ViewComponent::Base
  def initialize(score:)
    @score = score
  end

  def color_classes
    case @score
    when 0..20
      "bg-pink-100 text-pink-900"
    when 21..40
      "bg-yellow-100 text-yellow-900"
    when 41..60
      "bg-orange-200 text-orange-900"
    when 61..80
      "bg-emerald-200 text-emerald-900"
    when 81..100
      "bg-emerald-800 text-emerald-100"
    end
  end
end
