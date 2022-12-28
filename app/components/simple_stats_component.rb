# frozen_string_literal: true

class SimpleStatsComponent < ViewComponent::Base
  def initialize(title:, data:)
    @title = title
    @data = data
  end
end
