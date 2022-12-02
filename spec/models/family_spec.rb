# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Family) do
  let(:family) { create(:family) }

  describe "geocode" do
    it "geocodes when the address changes" do
      family.update(latitude: nil, longitude: nil)
      family.reload
      expect(family.latitude).not_to(be_present)
      expect(family.longitude).not_to(be_present)
      family.update(address_1: "123 Main St", city: "San Francisco", state: "CA", zip: "94105")
      family.reload
      expect(family.latitude).to(be_present)
      expect(family.longitude).to(be_present)
    end

    it "does not geocode when the address does not change" do
      family.update(latitude: nil, longitude: nil)
      family.reload
      expect(family.latitude).not_to(be_present)
      expect(family.longitude).not_to(be_present)
      family.update(name: "New Name")
      family.reload
      expect(family.latitude).not_to(be_present)
      expect(family.longitude).not_to(be_present)
    end
  end
end
