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
end
