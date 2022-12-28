# frozen_string_literal: true

class StackedBarChartComponent < ViewComponent::Base
  def initialize(data:, title:)
    @data = data
    @title = title
  end
end
