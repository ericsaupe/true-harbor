# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ResultsCsvGenerator) do
  let(:search) { create(:search) }

  it "generates a CSV file with only selected results" do
    result = create(:result, search: search)
    selected_result = create(:result, search: search, state: "selected")
    csv = described_class.generate_csv(search: search, only_selected: true)
    expect(csv).to(include(selected_result.family.name))
    expect(csv).not_to(include(result.family.name))
  end
end
