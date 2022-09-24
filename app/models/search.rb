# frozen_string_literal: true

class Search < ApplicationRecord
  serialize :query, JSON
end
