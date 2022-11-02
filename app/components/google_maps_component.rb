# frozen_string_literal: true

class GoogleMapsComponent < ViewComponent::Base
  def initialize(lat:, lng:, points: [])
    @lat = lat
    @lng = lng
    @points = points
  end
end
