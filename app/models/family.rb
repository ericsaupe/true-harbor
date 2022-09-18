# frozen_string_literal: true

class Family < ApplicationRecord
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

  def address
    [address_1, address_2, city, zip, state].compact.join(", ")
  end
end
