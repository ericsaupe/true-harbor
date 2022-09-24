# frozen_string_literal: true

class Search < ApplicationRecord
  serialize :query, JSON

  after_update_commit { broadcast_replace_later_to :searches_table, partial: "searches/search_table_row" }
end
