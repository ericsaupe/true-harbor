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
  end
end
