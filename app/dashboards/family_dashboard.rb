# frozen_string_literal: true

require "administrate/base_dashboard"

class FamilyDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    address_1: Field::String,
    address_2: Field::String,
    available_counselor_transportation: Field::Boolean,
    available_school_transportation: Field::Boolean,
    available_visit_transportation: Field::Boolean,
    availability: Field::Text,
    cats: Field::Boolean,
    city: Field::String,
    dogs: Field::Boolean,
    email: Field::String,
    exclusions: Field::HasMany,
    experience_with_care: Field::Text,
    icwa: Field::Boolean,
    last_contacted_at: Field::DateTime,
    latitude: Field::String.with_options(searchable: false),
    license_date: Field::Date,
    longitude: Field::String.with_options(searchable: false),
    name: Field::String,
    notes: Field::HasMany,
    on_break_end_date: Field::Date,
    on_break_start_date: Field::Date,
    organization: Field::BelongsTo,
    other_animals: Field::Boolean,
    other_children_in_home: Field::Number,
    phone: Field::String,
    race: Field::Select.with_options(searchable: false, collection: ->(field) {
                                                                      field.resource.class.send(
                                                                        field.attribute.to_s.pluralize,
                                                                      ).keys
                                                                    }),
    recreational_activities: Field::Text,
    region: Field::BelongsTo,
    religion: Field::Select.with_options(searchable: false, collection: ->(field) {
                                                                          field.resource.class.send(
                                                                            field.attribute.to_s.pluralize,
                                                                          ).keys
                                                                        }),
    results: Field::HasMany,
    searches: Field::HasMany,
    skills: Field::Text,
    spots_available: Field::Number,
    state: Field::String,
    status: Field::Select.with_options(searchable: false, collection: ->(field) {
                                                                        field.resource.class.send(
                                                                          field.attribute.to_s.pluralize,
                                                                        ).keys
                                                                      }),
    zip: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [:id, :name, :status, :region].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [:id, :address_1, :address_2, :available_counselor_transportation, :availability,
                          :available_school_transportation, :available_visit_transportation, :cats, :city, :dogs,
                          :email, :exclusions, :experience_with_care, :icwa, :last_contacted_at,
                          :latitude, :license_date, :longitude, :name, :notes, :on_break_end_date,
                          :on_break_start_date, :organization, :other_animals, :other_children_in_home, :phone, :race,
                          :recreational_activities, :region, :religion, :results, :searches, :skills, :spots_available,
                          :state, :status, :zip, :created_at, :updated_at,].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [:address_1, :address_2, :available_counselor_transportation, :available_school_transportation,
                     :availability, :available_visit_transportation, :cats, :city, :dogs, :email, :exclusions,
                     :experience_with_care, :icwa, :last_contacted_at, :latitude, :license_date,
                     :longitude, :name, :notes, :on_break_end_date, :on_break_start_date, :other_animals,
                     :other_children_in_home, :phone, :race, :recreational_activities, :region, :religion, :results,
                     :searches, :skills, :spots_available, :state, :status, :zip,].freeze

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

  # Overwrite this method to customize how families are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(family)
    "Family (#{family.name})"
  end
end
