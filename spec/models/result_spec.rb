# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Result) do
  let(:result) { create(:result) }
  let(:search) { result.search }
  let(:family) { result.family }

  describe "#calculate_score" do
    before do
      # We need to remove the defaults to ensure we are testing the calculation correctly
      family.experiences.destroy_all
      search.experiences.destroy_all
    end

    it "calculates child needs" do
      search.update(query: {})
      child_need = create(:child_need, organization: search.organization)
      create(:experience, experienceable: family, child_need: child_need)
      create(:experience, experienceable: search, child_need: child_need)
      result.calculate_score
      expect(result.score).to(eq(100))

      child_need = create(:child_need, organization: search.organization)
      create(:experience, experienceable: search, child_need: child_need)
      result.calculate_score
      expect(result.score).to(eq(50))
    end

    it "skips ICWA if ICWA is false" do
      family.update(icwa: true)
      search.update(query: { icwa: "false" })
      result.calculate_score
      expect(result.score).to(eq(100))
    end
  end
end
