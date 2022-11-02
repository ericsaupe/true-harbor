# frozen_string_literal: true

class HasManyScopedField < Administrate::Field::HasMany
  # apply a dynamic scope
  def candidate_resources
    associated_class.send(options.fetch(:model_scope))
  end

  # tell this field to use the views of the `Field::HasMany` parent class
  def to_partial_path
    "/fields/has_many/#{page}"
  end

  # apply the same class as the parent otherwise `selectize` (from JavaScript) doesn't apply
  def html_class
    "has-many"
  end
end
