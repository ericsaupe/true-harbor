# frozen_string_literal: true

class EmptyChartComponent < ViewComponent::Base
  def initialize(id:, path:, size: nil)
    @id = id
    @path = path
    @size = size
  end
end
