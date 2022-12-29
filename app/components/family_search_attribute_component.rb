# frozen_string_literal: true

class FamilySearchAttributeComponent < ViewComponent::Base
  def initialize(family:, search: nil, attribute:, label: nil, icon: nil)
    @family = family
    @search = search
    @attribute = attribute
    @label = label
  end

  def array_of_values?
    @family.send(@attribute).is_a?(Array) || @family.send(@attribute).is_a?(ActiveRecord::Relation)
  end

  def same_attribute?(attribute = nil)
    return false if @search.nil? || @family.nil?

    attribute ||= @attribute
    if attribute == "spots_available"
      @search&.query&.dig(attribute).to_i <= @family.send(attribute).to_i
    elsif [true, false].include?(@family.send(attribute))
      ActiveModel::Type::Boolean.new.cast(@search&.query&.dig(attribute)) == @family.send(attribute)
    else
      @search&.query&.dig(attribute) == @family.send(attribute)
    end
  end

  def search_has_attribute?(attribute = nil)
    attribute ||= @attribute
    (attribute == "icwa" && ActiveModel::Type::Boolean.new.cast(@search&.query&.dig(attribute))) ||
      (attribute != "icwa" && @search&.query&.dig(attribute).present?)
  end

  def item_in_array?(item)
    return false unless @search

    if @attribute == "child_needs"
      @search.child_needs.find_by(id: item.id).present?
    else
      @search.query&.dig(@attribute)&.include?(item)
    end
  end

  def search_items_missing_from_family
    return [] unless @search

    if @attribute == "child_needs"
      @search.child_needs.where.not(id: @family.child_needs.pluck(:id))
    else
      @search.query&.dig(@attribute)&.reject { |item| @family.send(@attribute).include?(item) } || []
    end
  end

  def display_attribute
    @label || @attribute.titleize
  end

  def display_value
    if @family.send(@attribute).is_a?(String)
      @family.send(@attribute).titleize
    elsif [true, false].include?(@family.send(@attribute))
      @family.send(@attribute) ? "Yes" : "No"
    elsif @family.send(@attribute).is_a?(Date)
      @family.send(@attribute).strftime("%b %-d %Y")
    elsif @family.send(@attribute).is_a?(Region) || @family.send(@attribute).is_a?(SchoolDistrict)
      @family.send(@attribute).name
    else
      @family.send(@attribute)
    end
  end
end
