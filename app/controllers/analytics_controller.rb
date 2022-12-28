# frozen_string_literal: true

class AnalyticsController < AuthenticatedController
  authorize_resource class: false

  def index; end

  def search_types
    @data = @organization.searches.group(:category).count.map { |type, count| { type: type.titleize, count: } }.to_json
  end
end
