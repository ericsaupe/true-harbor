# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Results") do
  let(:result) { create(:result) }
  let(:user) { create(:user, organization: organization) }
  let(:organization) { result.search.organization }

  before do
    change_domain(organization.subdomain)
    sign_in(user)
  end

  describe "state changes" do
    it "marks a result as selected" do
      visit search_path(result.search)
      select_button = find("[data-action='result#toggleSelected']", match: :first)
      select_button.click
      table_row = select_button.parent_node.parent_node.parent_node
      expect(table_row["data-result-state-value"]).to(eq("selected"))
      result.reload
      expect(result).to(be_selected)
    end

    it "marks a result as declined" do
      visit search_path(result.search)
      select_button = find("[data-action='result#toggleDeclined']", match: :first)
      select_button.click
      table_row = select_button.parent_node.parent_node.parent_node
      expect(table_row["data-result-state-value"]).to(eq("declined"))
      result.reload
      expect(result).to(be_declined)
    end

    it "marks a result as waiting" do
      visit search_path(result.search)
      select_button = find("[data-action='result#toggleWaiting']", match: :first)
      select_button.click
      table_row = select_button.parent_node.parent_node.parent_node
      expect(table_row["data-result-state-value"]).to(eq("waiting"))
      result.reload
      expect(result).to(be_waiting)
    end
  end

  describe "contacted" do
    it "marks a result as contacted" do
      time = Time.zone.local(2022, 1, 1, 12, 0, 0)
      Timecop.freeze(time) do
        visit search_path(result.search)
        contact_button = find("[data-action='result#updateContacted']", match: :first)
        contact_button.click
        expect(contact_button).to(be_disabled)
        expect(page).to(have_content("Just now"))
        result.family.reload
        expect(result.family.last_contacted_at).to(eq(time))
      end
    end
  end

  describe "add additional families" do
    it "displays families in the search that aren't in the original results" do
      family = create(:family, organization: organization)
      visit search_path(result.search)
      find_by_id("combobox").send_keys(family.name)
      expect(page).to(have_css("#family_#{family.id}"))
    end

    it "adds additional families when clicked" do
      family = create(:family, organization: organization)
      visit search_path(result.search)
      expect(page).not_to(have_content(family.phone))
      find_by_id("combobox").send_keys(family.name)
      find("#family_#{family.id}").click
      expect(page).to(have_content(family.phone))
    end

    it "removes families when clicked" do
      family = result.family
      visit search_path(result.search)
      expect(page).to(have_content(family.phone))
      find_by_id("combobox").send_keys(family.name)
      find("#family_#{family.id}").click
      expect(page).not_to(have_content(family.phone))
    end
  end
end
