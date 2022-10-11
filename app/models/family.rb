# frozen_string_literal: true

class Family < ApplicationRecord
  include Organizable
  include Noteable

  has_many :results, dependent: :destroy
  has_many :searches, through: :results

  encrypts :address_1, :address_2
  encrypts :city, :state, :region, deterministic: true

  enum :family_interest, [:respite, :short_term, :long_term, :adoption, :any]
  enum :race, [:american_indian, :asian, :black, :islander, :hispanic, :white, :other_race]
  enum :religion, [:christianity, :islam, :judaism, :non_religous, :other_religion]
  enum :status, [:open, :hold, :closed]

  serialize :experience_with_care, JSON
  serialize :recreational_activities, JSON
  serialize :skills, JSON

  geocoded_by :address
  after_validation :geocode

  after_update_commit do
    broadcast_replace_later_to :families_table, partial: "families/family_table_row"
  end

  after_update_commit -> {
    results.includes(:search).where(searches: { completed_at: nil }).find_each(&:broadcast_changes)
  }

  class << self
    def recreational_activities
      [
        "Sports",
        "Traveling",
        "Camping / fishing",
        "Family game/movie night",
        "Video games",
        "Horseback riding",
        "Church / youth group",
      ].sort
    end

    def regions
      [
        "1",
      ]
    end

    def skills
      [
        "Trauma training",
        "Medical degree /training",
        "Spec. Ed degree/tutor/training",
        "Counseling degree",
        "Law enforcement",
        "Bi-lingual",
        "ASL",
      ].sort
    end

    def experience_with_care
      [
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
      ].sort
    end
  end

  def address
    [address_1, address_2, city, state, zip].compact.join(", ")
  end
end
