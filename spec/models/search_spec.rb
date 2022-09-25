# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Search, type: :model) do
  describe "#find_families" do
    it "finds families with exact matches" do
      search = create(:search)
      family = create(:family, city: "Coeur d'Alene", state: "ID", region: "1", zip: "83815")
      expect(search.find_families).to(eq([family]))
    end
  end
end
