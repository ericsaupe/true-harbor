# frozen_string_literal: true

module FamilyHelper
  def same_attribute?(search, family, attribute)
    return false if search.nil? || family.nil?

    search&.query&.dig(attribute) == family.send(attribute)
  end
end
