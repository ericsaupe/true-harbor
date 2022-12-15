# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Result) do
  let(:result) { create(:result) }
  let(:search) { result.search }
  let(:family) { result.family }

  describe "#calculate_score" do
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
  end
end
