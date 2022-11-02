# frozen_string_literal: true

require "administrate/custom_dashboard"

class ImportDashboard < Administrate::CustomDashboard
  resource "Imports" # used by administrate in the views
end
