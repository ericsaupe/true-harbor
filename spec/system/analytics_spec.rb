# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Admin") do
  let(:admin) { create(:admin) }
  let(:organization) { admin.organization }
  let(:user) { create(:user, organization: organization) }

  context "when unauthorized" do
    before do
      change_domain(organization.subdomain)
      sign_in(user)
    end

    it "does not render the menu items" do
      visit("/")
      expect(page).not_to(have_content("Analytics"))
    end
  end

  context "when authorized" do
    before do
      change_domain(organization.subdomain)
      sign_in(admin)
    end

    it "renders the menu items" do
      visit("/")
      expect(page).to(have_content("Analytics"))
    end

    it "renders the charts" do
      visit("/analytics")
      expect(page).to(have_selector("[data-controller=\"charts--pie-chart\"]"))
      expect(page).to(have_selector("[data-controller=\"charts--stacked-bar-chart\"]"))
      expect(page).to(have_content("Average Completed Search Times"))
    end

    it "renders the average time to complete table" do
      Timecop.freeze do
        create(:search, organization: organization, created_at: 1.day.ago, completed_at: 1.day.ago + 10.minutes)
        create(:search, organization: organization, created_at: 1.day.ago, completed_at: 1.day.ago + 20.minutes)
      end

      visit("/analytics")
      expect(page).to(have_content("Average Completed Search Times"))
      expect(page).to(have_content("15 minutes"))
    end
  end
end
