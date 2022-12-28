# frozen_string_literal: true

class EmptyGraphComponent < ViewComponent::Base
  def initialize(id:, path:, size: nil)
    @id = id
    @path = path
    @size = size
  end
end
