# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Search) do
  let(:search) { create(:search) }
  let!(:family) { create(:family, organization: search.organization, availability: search.query["availability"]) }

  describe "#find_families" do
    it "finds families with exact matches" do
      expect(search.find_families).to(eq([family]))
    end

    it "supports multiple availabilities in one result" do
      family.update(availability: Family.availabilities) # all availabilities
      # create one of each family
      Family.availabilities.each do |availability|
        create(:family, organization: search.organization, availability: [availability])
      end
      search.update(query: { "availability" => Family.availabilities.sample(2) }) # Choose two availabilites
      # Should find three families, one for each availability and the one with all the availabilites
      expect(search.find_families.count).to(eq(3))
    end
  end

  describe "#calculate_results" do
    it "creates results for each family" do
      search.calculate_results
      expect(search.results).to(eq(Result.where(search: search, family: family)))
    end
  end

  describe "#completed?" do
    it "returns true if the search is completed" do
      search.update(completed_at: Time.current)
      expect(search.completed?).to(be(true))
    end

    it "returns false if the search is not completed" do
      expect(search.completed?).to(be(false))
    end
  end

  describe "#results_without_exclusions" do
    it "returns results without exclusions" do
      create(:exclusion, family: family, gender: :any, comparator: :less_than, age: 5)
      create(:exclusion, family: family, gender: :girl, comparator: :less_than, age: 6)
      search = create(:search)
      create(:child, search: search, gender: :boy, age: 4)
      expect(search.results_without_exclusions).to(eq([]))
    end

    it "really returns results without exclusions" do
      create(:exclusion, family: family, gender: :any, comparator: :less_than, age: 15)
      create(:exclusion, family: family, gender: :boy, comparator: :less_than, age: 1)
      search = create(:search)
      create(:child, search: search, gender: :boy, age: 7)
      create(:child, search: search, gender: :other, age: 18)
      expect(search.results_without_exclusions).to(eq([]))
    end
  end
end
