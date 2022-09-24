# frozen_string_literal: true

class EmptyStateComponent < ViewComponent::Base
  def initialize(klass:)
    @klass = klass
  end
end
