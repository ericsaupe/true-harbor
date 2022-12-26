# frozen_string_literal: true

class AnalyticsController < AuthenticatedController
  authorize_resource class: false

  def index; end
end
