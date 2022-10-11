# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Families", type: :system) do
  let(:user) { create(:user) }
  let(:organization) { user.organization }

  before do
    change_domain(organization.subdomain)
    sign_in(user)
  end

  describe "index" do
    it "shows all families" do
      families = create_list(:family, 3, organization: organization)
      visit "/families"
      families.each do |family|
        expect(page).to(have_text(family.name))
      end
    end
  end

  describe "edit" do
    it "renders the edit form" do
      family = create(:family, organization: organization)
      visit "/"
      click_on("Families")
      find("[data-test='edit-button']").click
      expect(page).to(have_text(family.name))
      expect(page).to(have_button("Update Family"))
    end
  end

  describe "update" do
    it "allows updating a family" do
      family = create(:family, organization: organization)
      visit edit_family_path(family)
      fill_in("Name", with: "New Name")
      check("Transport to visits")
      click_on("Update Family")
      expect(page).to(have_text("Successfully updated family."))
      expect(page).to(have_text("New Name"))
      expect(family.reload.available_visit_transportation).to(be(true))
    end
  end
end
