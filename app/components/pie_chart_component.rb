# frozen_string_literal: true

class PieChartComponent < ViewComponent::Base
  def initialize(data:, title:)
    @data = data
    @title = title
  end
end
