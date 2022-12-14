# frozen_string_literal: true

class Family < ApplicationRecord
  include Organizable
  include Noteable

  has_many :results, dependent: :destroy
  has_many :searches, through: :results
  has_many :exclusions, dependent: :destroy
  has_many :experiences, as: :experienceable, dependent: :destroy
  has_many :child_needs, through: :experiences
  belongs_to :region, optional: true
  belongs_to :school_district, optional: true

  accepts_nested_attributes_for :experiences, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :exclusions, allow_destroy: true, reject_if: :all_blank

  encrypts :address_1, :address_2
  encrypts :city, :state, :region, deterministic: true

  validate :on_break_dates_are_valid

  enum :race, [:american_indian, :asian, :black, :islander, :hispanic, :white, :other_race]
  enum :religion, [:christianity, :islam, :judaism, :non_religous, :other_religion]
  enum :status, [:open, :hold, :closed]

  serialize :availability, Array
  ransacker :availabilities_raw, type: :string do
    Arel.sql("families.availability")
  end

  serialize :experience_with_care, JSON
  serialize :recreational_activities, JSON
  serialize :skills, JSON
  serialize :phone

  # Don't geocode if we are manually setting their location
  after_commit :geocode_later, if: :should_geocode?
  geocoded_by :address

  scope :not_on_break, -> {
                         where(
                           "(on_break_start_date IS NULL OR on_break_start_date > :today) AND
                                (on_break_end_date IS NULL OR on_break_end_date < :today)",
                           today: Date.current,
                         )
                       }
  scope :including_any_availabilities, ->(availabilities) { where(matching_availability_query(availabilities, "OR")) }

  after_update_commit do
    broadcast_replace_later_to :families_table, partial: "families/family_table_row"
  end

  after_update_commit -> {
    results.includes(:search).where(searches: { completed_at: nil }).find_each(&:broadcast_changes)
  }

  class << self
    def availabilities
      [
        "Respite",
        "Short term",
        "Long term",
        "Adoption",
      ].freeze
    end

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

    def matching_availability_query(availabilities, condition_separator = "OR")
      availabilities.map { |availability| "(availability LIKE '%#{availability}%')" }.join(" #{condition_separator} ")
    end
  end

  def address
    [address_1, address_2, city, state, zip].compact.join(", ")
  end

  def on_break?
    (on_break_start_date.present? && on_break_start_date <= Date.current) ||
      (on_break_end_date.present? && on_break_end_date >= Date.current)
  end

  def on_break_dates_are_valid
    if on_break_start_date.present? && on_break_end_date.present? && on_break_start_date > on_break_end_date
      errors.add(:on_break_start_date, "must be before the end date")
    end
  end

  def remove_whitespace_from_phone
    self.phone = phone.gsub(/\s+/, "") if phone.present?
  end

  def geocode_later
    GeocoderJob.perform_async(id)
  end

  private

  def should_geocode?
    # Don't geocode if we are manually setting their location
    !(saved_change_to_latitude? || saved_change_to_longitude?) &&
      (saved_change_to_address_1? ||
      saved_change_to_address_2? ||
      saved_change_to_city? ||
      saved_change_to_state? ||
      saved_change_to_zip?)
  end
end
