# frozen_string_literal: true

class OrganizationSeeder
  attr_reader :organization

  def initialize(organization)
    @organization = organization
  end

  def seed
    seed_child_needs
  end

  def seed_child_needs
    needs = [
      "In utero exposure to substances",
      "Medically fragile / preemie infant",
      "Developmental delays",
      "Wheelchair",
      "Potty issues",
      "Hearing loss / auditory processing",
      "Eye issues / blindness",
      "Sensory processing issues",
      "Dysregulation / tantrums",
      "Aggression / violence / conduct disorders",
      "Neurodivergent / ASD / ADHD",
      "School issues / IEP / 504",
      "Mental health diagnoses",
      "Food issues",
      "Substance use",
      "LGBTQ+",
      "Sexually acting out",
    ]
    needs.each do |need|
      organization.child_needs.find_or_create_by(name: need)
    end
  end
end
