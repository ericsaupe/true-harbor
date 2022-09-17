# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :confirmable, :lockable, :timeoutable, :trackable,
    :omniauthable

  encrypts :email, :first_name, :last_name, deterministic: true
  encrypts :phone
end
