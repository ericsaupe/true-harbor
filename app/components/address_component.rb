# frozen_string_literal: true

class AddressComponent < ViewComponent::Base
  def initialize(family:)
    @family = family
  end
end
