# frozen_string_literal: true

module CapybaraExtensions
  def parent_node
    find(:xpath, "..")
  end
end
