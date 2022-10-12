# frozen_string_literal: true

class FormErrorsComponent < ViewComponent::Base
  def initialize(errors:)
    @errors = errors
  end

  def error_message
    if @errors.count > 1
      "There were #{@errors.count} errors with your submission"
    else
      "There was #{@errors.count} error with your submission"
    end
  end
end
