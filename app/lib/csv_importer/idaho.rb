# frozen_string_literal: true

module CsvImporter
  class Idaho < Base
    HEADERS = [
      "name",
      "notes/preferences",
      "phone",
      "address",
      "city",
      "zip",
      "m/f", # age ranges and gender of children they are looking for
      "age", # ???
      "lic#", # number of children they are available for
      "type", # what type of care they are looking for
      "orig.lic.date", # date they were licensed
      "lic.expir.date.", # date their license expires
    ].freeze

    def parse_row(row)
      family_params = {
        name: name(row["name"]),
        email: row["email"],
        phone: row["phone"],
        address_1: row["address"],
        city: row["city"],
        state: "ID",
        zip: row["zip"] || row["zipcode"],
        family_interest: family_interest(row["type"]),
        spots_available: row["lic"],
        license_date: license_date(row["orig.lic.date"]),
        region: region(row["region"]),
        status: row["status"]&.downcase || :open,
      }
      family = organization.families.find_by(name: name(row["name"]))
      if family.nil?
        family = organization.families.create!(family_params)
      else
        family.update!(family_params)
      end

      create_exclusions(family, row["m/f"] || row["age"])
      create_notes(family, row["notes/preferences"])
    end

    def name(name_value)
      remove_new_lines = name_value.split("\n").first
      split_on_space = remove_new_lines.split("  ").map(&:strip).first
      split_on_comma = split_on_space.split(",").map(&:strip)
      full_name = split_on_comma.reverse.join(" ")
      full_name
    end

    def license_date(date)
      Date.strptime(date, "%m/%d/%y")
    end

    def family_interest(type)
      types_array = type.split(" ").map(&:strip).map(&:downcase)
      possible_types = ["gen", "f/c", "adopt", "respite"]
      if (types_array & possible_types).size > 1
        :any
      elsif types_array.include?("gen")
        :long_term
      elsif types_array.include?("f/c")
        :short_term
      elsif types_array.include?("adopt")
        :adoption
      elsif types_array.include?("respite")
        :respite
      else
        raise "Unknown type: #{type}"
      end
    end

    def create_exclusions(family, age_ranges)
      age_ranges.split("\n").each do |ages|
        age, gender = ages.split(" ")
        gender = if gender.nil?
          :any
        elsif gender.downcase.include?("m")
          :boy
        elsif gender.downcase.include?("f")
          :girl
        else
          :any
        end
        min_age, max_age = age.split("-").map(&:to_i)
        if min_age.positive?
          family.exclusions.find_or_create_by!(
            gender: gender,
            comparator: :less_than,
            age: min_age,
          )
        end
        family.exclusions.find_or_create_by!(
          gender: gender,
          comparator: :greater_than,
          age: max_age,
        )
      end
    end

    def create_notes(family, notes)
      notes.split("\n").each do |note|
        family.notes.find_or_create_by!(content: note)
      end
    end

    def region(region_name)
      organization.regions.find_or_create_by!(name: region_name) if region_name
    end
  end
end
