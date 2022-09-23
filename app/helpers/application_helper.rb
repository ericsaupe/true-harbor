# frozen_string_literal: true

module ApplicationHelper
  def flash_class(type)
    case type.to_s
    when "success"
      "bg-emerald-600"
    when "error"
      "bg-red-600"
    when "warning"
      "bg-yellow-600"
    else
      "bg-pink-600"
    end
  end
end
