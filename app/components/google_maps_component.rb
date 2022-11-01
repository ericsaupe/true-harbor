# frozen_string_literal: true

class GoogleMapsComponent < ViewComponent::Base
  def initialize(lat:, lng:, points: [])
    @lat = lat
    @lng = lng
    @points = points
  end

  def google_maps_api_key
    ENV.fetch("GOOGLE_MAPS_API_KEY", Rails.application.credentials.dig(:google_maps, :api_key))
  end
end
