# frozen_string_literal: true

namespace :data_fix do
  task convert_family_interest_to_availability: :environment do
    raise "This task is only needed while the family_interest column is present" unless Family.column_names.include?(
      "family_interest",
    )

    Family.find_each do |family|
      case family.family_interest
      when "respite"
        family.availability << "Respite" unless family.availability.include?("Respite")
      when "short_term"
        family.availability << "Short term" unless family.availability.include?("Short term")
      when "long_term"
        family.availability << "Long term" unless family.availability.include?("Long term")
      when "adoption"
        family.availability << "Adoption" unless family.availability.include?("Adoption")
      when "any"
        family.availability = Family.availabilities
      end
      family.save!
    end
  end
end
