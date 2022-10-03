# frozen_string_literal: true

module Organizable
  extend ActiveSupport::Concern

  included do
    belongs_to :organization
  end
end
