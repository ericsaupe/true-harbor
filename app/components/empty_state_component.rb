# frozen_string_literal: true

class EmptyStateComponent < ViewComponent::Base
  def initialize(klass:, object: nil)
    @klass = klass
    @object = object
  end
end
