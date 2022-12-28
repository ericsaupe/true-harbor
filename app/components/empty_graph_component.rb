# frozen_string_literal: true

class EmptyGraphComponent < ViewComponent::Base
  def initialize(id:, path:)
    @id = id
    @path = path
  end
end
