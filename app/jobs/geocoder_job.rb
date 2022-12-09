# frozen_string_literal: true

class GeocoderJob < ApplicationJob
  def perform(id)
    family = Family.find(id)
    family.geocode
    family.save
  end
end
