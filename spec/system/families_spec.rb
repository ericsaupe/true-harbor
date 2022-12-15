# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Families") do
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

  describe "create" do
    it "saves experiences" do
      child_needs = create_list(:child_need, 3, organization: organization)
      visit new_family_path
      fill_in("Name", with: "New Family")
      fill_in("Email", with: Faker::Internet.email)
      fill_in("Street address", with: Faker::Address.street_address)
      fill_in("ZIP / Postal code", with: Faker::Address.zip)
      check(child_needs.first.name)
      click_on("Create Family")
      expect(page).to(have_text("Successfully created family."))
      family = Family.last
      expect(family.reload.experiences.pluck(:child_need_id)).to(eq([child_needs.first.id]))
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

    it "renders the notes form" do
      create(:family, organization: organization)
      visit "/"
      click_on("Families")
      find("[data-test='edit-button']").click
      expect(page).to(have_text("Notes and History"))
      expect(page).to(have_button("Create Note"))
    end
  end

  describe "update" do
    it "allows updating a family" do
      family = create(:family, organization: organization)
      region = create(:region, organization: organization)
      visit edit_family_path(family)
      fill_in("Name", with: "New Name")
      select(region.name, from: "Region")
      check("Transport to visits")
      click_on("Update Family")
      expect(page).to(have_text("Successfully updated family."))
      expect(page).to(have_text("New Name"))
      expect(family.reload.available_visit_transportation).to(be(true))
      expect(family.reload.region).to(eq(region))
    end

    it "saves experiences" do
      family = create(:family, :with_experiences, organization: organization)
      new_child_need = create(:child_need, organization: organization)
      expect(family.reload.experiences.pluck(:child_need_id)).not_to(include(new_child_need.id))
      experience = family.experiences.first
      visit edit_family_path(family)
      check(new_child_need.name)
      uncheck(experience.name)
      click_on("Update Family")
      expect(page).to(have_text("Successfully updated family."))
      expect(family.reload.experiences).not_to(include(experience))
      expect(family.reload.experiences.pluck(:child_need_id)).to(include(new_child_need.id))
    end
  end
end
