# frozen_string_literal: true

task generate_data: :environment do
  raise "This task is only for development" unless Rails.env.development?

  # Create families
  FactoryBot.create_list(:family, 100)
end
