# frozen_string_literal: true

class UserRole < ApplicationRecord
  belongs_to :role
  belongs_to :user
end
