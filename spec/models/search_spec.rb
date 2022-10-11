# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Search, type: :model) do
  let(:search) { create(:search) }
  let!(:family) { create(:family) }

  describe "#find_families" do
    it "finds families with exact matches" do
      expect(search.find_families).to(eq([family]))
    end
  end

  describe "#calculate_results" do
    it "creates results for each family" do
      search.calculate_results
      expect(search.results).to(eq([Result.find_by(search: search, family: family)]))
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
end
