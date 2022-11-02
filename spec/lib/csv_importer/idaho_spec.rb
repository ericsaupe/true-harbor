# frozen_string_literal: true

require "rails_helper"

RSpec.describe(CsvImporter::Idaho) do
  describe "#self.import" do
    it "imports a CSV file" do
      organization = create(:organization)
      file = file_fixture("idaho.csv")
      expect do
        described_class.import(organization, file)
      end.to(change(ParseRowJob.jobs, :size).by(1))
      Sidekiq::Worker.drain_all
      expect(organization.families.count).to(eq(1))
      family = organization.families.first
      expect(family.name).to(eq("First Last"))
      expect(family.address_1).to(eq("123 Fake Street"))
      expect(family.city).to(eq("CDA"))
      expect(family.state).to(eq("ID"))
      expect(family.zip).to(eq("83815"))
      expect(family.phone).to(eq("555-123-4567"))
      expect(family.spots_available).to(eq(2))
      expect(family.license_date).to(eq(Date.parse("2022-02-01")))
      expect(family.family_interest).to(eq("any"))
      # Verify exclusions were imported correctly
      expect(family.exclusions.count).to(eq(1))
      exclusion = family.exclusions.first
      expect(exclusion.comparator).to(eq("greater_than"))
      expect(exclusion.age).to(eq(7))
      # Verify notes were imported correctly
      expect(family.notes.count).to(eq(1))
      note = family.notes.first
      expect(note.content).to(eq("*OPEN, prefer 0-6, have room for two, will not take anyone over age 7"))
      expect(note.user).to(be_nil)
    end
  end
end
