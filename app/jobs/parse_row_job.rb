# frozen_string_literal: true

class ParseRowJob < ApplicationJob
  def perform(klass, organization_id, row)
    organization = Organization.find(organization_id)
    klass.constantize.new(organization, nil).parse_row(row)
  end
end
