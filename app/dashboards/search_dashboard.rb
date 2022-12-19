# frozen_string_literal: true

require "administrate/base_dashboard"

class SearchDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    category: Field::Select.with_options(searchable: false, collection: ->(field) {
                                                                          field.resource.class.send(
                                                                            field.attribute.to_s.pluralize,
                                                                          ).keys
                                                                        }),
    children: Field::HasMany,
    completed_at: Field::DateTime,
    families: Field::HasMany,
    name: Field::String,
    organization: Field::BelongsTo,
    query: Field::Text,
    results: Field::HasMany,
    child_needs: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [:id, :category, :children, :completed_at].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [:id, :category, :children, :completed_at, :families, :name, :organization, :query, :results,
                          :child_needs, :created_at, :updated_at,].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [:category, :completed_at, :name].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how searches are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(search)
    "Search (#{search.name})"
  end
end
