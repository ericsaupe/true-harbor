# frozen_string_literal: true

class TableDataComponent < ViewComponent::Base
  def initialize(position: nil, classes: [])
    @position = position
    @classes = classes
  end

  def class_list
    default_classes = ["border-b", "border-gray-200", "px-3", "py-4", "text-sm", "text-gray-500"]
    first_classes = ["pl-4", "pr-3", "font-medium", "sm:pl-6", "lg:pl-8"]
    last_classes = ["relative", "pr-4", "pl-3", "text-right", "font-medium", "sm:pr-6", "lg:pr-8"]

    classes = default_classes
    if @position == "first"
      classes += first_classes
      classes - ["px-3"] # Remove px-3 from classes because we override the left padding
    elsif @position == "last"
      classes += last_classes
      classes - ["px-3"] # Remove px-3 from classes because we override the right padding
    end
    # Add any additional classes passed in
    classes += @classes
    classes.join(" ")
  end
end
