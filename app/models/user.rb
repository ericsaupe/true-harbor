# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  include Organizable

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :confirmable, :lockable, :timeoutable, :trackable,
    :omniauthable

  encrypts :first_name, :last_name, deterministic: true
  encrypts :phone

  def display_name
    first_name && last_name ? "#{first_name} #{last_name}" : email
  end
end
