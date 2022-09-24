# frozen_string_literal: true

module FormatSerializedFields
  def format_serialized_fields(parameters)
    parameters[:experience_with_care] = parameters[:experience_with_care]&.keys
    parameters[:recreational_activities] = parameters[:recreational_activities]&.keys
    parameters[:skills] = parameters[:skills]&.keys
    parameters
  end
end
