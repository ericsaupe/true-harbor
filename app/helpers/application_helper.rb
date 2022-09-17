# frozen_string_literal: true

module ApplicationHelper
  def flash_class(type)
    case type
    when "success"
      "bg-green-600"
    when "error"
      "bg-red-600"
    when "warning"
      "bg-yellow-600"
    else
      "bg-blue-600"
    end
  end
end
