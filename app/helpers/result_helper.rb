# frozen_string_literal: true

module ResultHelper
  def result_row_bg_class(result)
    case result.state
    when "selected"
      "bg-emerald-50"
    when "declined"
      "bg-red-50"
    when "waiting"
      "bg-yellow-50"
    else
      "bg-white"
    end
  end
end
