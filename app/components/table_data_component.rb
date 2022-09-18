# frozen_string_literal: true

class TableDataComponent < ViewComponent::Base
  def initialize(position: nil)
    @position = position
  end

  def class_list
    if @position == "first"
      "whitespace-nowrap border-b border-gray-200 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:pl-6 lg:pl-8"
    elsif @position == "last"
      "relative whitespace-nowrap border-b border-gray-200 py-4 pr-4 pl-3 text-right text-sm font-medium
       sm:pr-6 lg:pr-8"
    else
      "whitespace-nowrap border-b border-gray-200 px-3 py-4 text-sm text-gray-500"
    end
  end
end
