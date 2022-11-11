# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Search") do
  let(:user) { create(:user) }
  let(:organization) { user.organization }

  before do
    change_domain(organization.subdomain)
    sign_in(user)
  end

  describe "index" do
    it "shows all searches" do
      searches = create_list(:search, 3, organization: organization)
      visit "/searches"
      searches.each do |search|
        expect(page).to(have_text(search.name))
      end
    end

    it "does not render the edit button if the search is completed" do
      create(:search, organization: organization, completed_at: Time.current)
      visit "/searches"
      expect(page).not_to(have_selector("[data-test='edit-button']"))
    end
  end

  describe "create" do
    it "hard filters by availability" do
      respite_family = create(:family, organization: organization, availability: ["Respite"])
      respite_and_short_term_family = create(:family, organization: organization,
        availability: ["Respite", "Short Term"])
      adoption_family = create(:family, organization: organization, availability: ["Adoption"])
      visit "/searches/new"
      fill_in("Search name", with: "Test")
      check("Respite")
      click_on("Create Search")
      expect(page).to(have_text(respite_family.name))
      expect(page).to(have_text(respite_and_short_term_family.name))
      expect(page).not_to(have_text(adoption_family.name))
    end

    it "hard filters by school district" do
      school_district = create(:school_district, organization: organization)
      school_district_family = create(:family, organization: organization, school_district: school_district)
      other_school_district_family = create(:family, organization: organization)
      visit "/searches/new"
      fill_in("Search name", with: "Test")
      check(school_district.name)
      click_on("Create Search")
      expect(page).to(have_text(school_district_family.name))
      expect(page).not_to(have_text(other_school_district_family.name))
    end
  end

  describe "edit" do
    it "renders the edit form" do
      search = create(:search, organization: organization)
      visit "/"
      click_on("Searches")
      find("[data-test='edit-button']", match: :first).click
      expect(page).to(have_text(search.name))
      expect(page).to(have_button("Update Search"))
    end
  end

  describe "update" do
    it "allows updating a search" do
      search = create(:search, organization: organization)
      visit edit_search_path(search)
      fill_in("Search name", with: "New Name")
      check("Transport to visits")
      click_on("Update Search")
      expect(page).to(have_text("Successfully updated search."))
      expect(page).to(have_text("New Name"))
      expect(
        ActiveModel::Type::Boolean.new.cast(
          search.reload.query.dig("available_visit_transportation"),
        ),
      ).to(be(true))
    end
  end
end
