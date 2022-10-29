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
      family = organization.families.create!(
        name: name(row["name"]),
        email: row["email"],
        phone: phone(row["phone"]),
        address_1: row["address"],
        city: row["city"],
        state: "ID",
        zip: row["zip"] || row["zipcode"],
        family_interest: family_interest(row["type"]),
        spots_available: row["lic"],
        license_date: license_date(row["orig.lic.date"]),
      )

      create_exclusions(family, row["m/f"] || row["age"])
      create_notes(family, row["notes/preferences"])
    end

    def name(name)
      name.split("\n").first.split("  ").map(&:strip).first.split(",").map(&:strip).reverse.join(" ")
    end

    def phone(phone)
      return if phone.nil?

      phone&.gsub!(/[^0-9-]/, "")
      phone
    end

    def license_date(date)
      Date.strptime(date, "%m/%d/%y")
    end

    def family_interest(type)
      types_array = type.split(" ").map(&:strip).map(&:downcase)
      possible_types = ["gen", "f/c", "adopt"]
      if (types_array & possible_types).size > 1
        :any
      elsif types_array.include?("gen")
        :long_term
      elsif types_array.include?("f/c")
        :short_term
      elsif types_array.include?("adopt")
        :adoption
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
        end
        min_age, max_age = age.split("-").map(&:to_i)
        if min_age.positive?
          family.exclusions.create!(
            gender: gender,
            comparator: :less_than,
            age: min_age,
          )
        end
        family.exclusions.create!(
          gender: gender,
          comparator: :greater_than,
          age: max_age,
        )
      end
    end

    def create_notes(family, notes)
      notes.split("\n").each do |note|
        family.notes.create!(content: note)
      end
    end
  end
end
