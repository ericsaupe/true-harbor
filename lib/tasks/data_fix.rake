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

  task seed_child_needs_to_organizations: :environment do
    Organization.find_each do |organization|
      OrganizationSeeder.new(organization).seed_child_needs
    end
  end

  task convert_legacy_skills_to_child_needs: :environment do
    legacy_experience_with_care = [
      "Line of sight supervision",
      "Attachment issues",
      "RAD",
      "Borderline personality disorder",
      "Bipolar",
      "Depression",
      "Anxiety",
      "ODD",
      "Developmental delays",
      "Medical hospitalizations",
      "Behavioral hospitalizations",
      "Sexual abuse",
      "LGBTQ+",
      "Transgender",
      "Autism spectrum disorder",
      "ADHD",
      "Addiction",
      "Disability / handicap",
      "Bedwetting",
      "Food issues / Eating disorders",
      "Encopresis / Enuresis",
      "Violence",
      "Preemies / NICU / edically fragile / failure to thrive",
      "Infants",
      "Toddlers",
      "Pre-school age children",
      "School-age children",
      "Teenagers",
      "Drug affected",
      "FASD",
      "Special education / IEP / 504",
      "Explosive behavior",
      "Dysregulation",
      "Sensory processing disorder",
      "Blind",
      "Deaf",
    ]

    progress_bar = ProgressBar.create(
      total: Organization.all.count + Family.all.count + Search.all.count + Result.all.count,
    )

    Organization.all.find_each do |organization|
      legacy_experience_with_care.each do |legacy_child_need|
        ChildNeed.find_or_create_by(name: legacy_child_need, organization: organization)
      end
      progress_bar.increment
    end

    Family.all.find_each do |family|
      legacy_experience_with_care.each do |legacy_child_need|
        if family.experience_with_care&.include?(legacy_child_need)
          child_need = ChildNeed.find_or_create_by(name: legacy_child_need, organization: family.organization)
          Experience.find_or_create_by(experienceable: family, child_need: child_need)
        end
      end
      progress_bar.increment
    end

    Search.all.find_each do |search|
      legacy_experience_with_care.each do |legacy_child_need|
        if search.query&.dig("experience_with_care")&.include?(legacy_child_need)
          child_need = ChildNeed.find_or_create_by(name: legacy_child_need, organization: search.organization)
          Experience.find_or_create_by(experienceable: search, child_need: child_need)
        end
      end
      search.save unless search.completed? # trigger callbacks
      progress_bar.increment
    end

    Result.all.find_each do |result|
      result.save
      progress_bar.increment
    end
  end
end
