# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Families", type: :system) do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  it "displays families" do
    create_list(:family, 3)
    visit "/"
    Family.all.find_each do |family|
      expect(page).to(have_text(family.name))
    end
  end

  describe "update" do
    it "allows updating a family" do
      family = create(:family)
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
