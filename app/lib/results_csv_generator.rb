# frozen_string_literal: true

require "csv"

class ResultsCsvGenerator
  class << self
    def generate_csv(search:, only_selected: false)
      family_attributes = [
        "name",
        "address_1",
        "address_2",
        "city",
        "state",
        "zip",
        "phone",
        "email",
        "license_date",
        "availability",
      ]
      state = only_selected ? "selected" : ["selected", "declined", "default"]
      results = search.results.includes(:family).where(state: state).order(score: :desc)

      CSV.generate(headers: true) do |csv|
        csv << family_attributes

        results.find_each do |result|
          csv << family_attributes.map { |attr| result.family.send(attr) }
        end
      end
    end
  end
end
