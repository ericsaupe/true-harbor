# frozen_string_literal: true

task generate_data: :environment do
  raise "This task is only for development" unless Rails.env.development? || ENV["FORCE_GENERATE_DATA"]

  # Create users
  FactoryBot.create(:user, email: "admin@localhost")
  10.times do |i|
    FactoryBot.create(:user, email: "user#{i}@example.com")
  end
  # Create families
  FactoryBot.create_list(:family, 100)
end
