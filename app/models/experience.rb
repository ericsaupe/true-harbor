# frozen_string_literal: true

class Experience < ApplicationRecord
  belongs_to :experienceable, polymorphic: true
  belongs_to :child_need

  delegate :name, to: :child_need
end
