# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Admin") do
  let(:admin) { create(:admin) }
  let(:organization) { admin.organization }

  before do
    change_domain(organization.subdomain)
    sign_in(admin)
  end

  it "renders the admin" do
    visit "/admin"
    expect(page).to(have_text("Back to app"))
  end

  it "renders the admin in production mode" do
    allow(Rails).to(receive(:env).and_return("production".inquiry)) # rubocop:disable Rails/Inquiry
    visit "/admin"
    expect(page).to(have_text("Back to app"))
  end

  it "queues up import jobs" do
    visit "/admin/imports/new"
    attach_file("File", Rails.root.join("spec/fixtures/files/idaho.csv"))
    click_on("Save")
    expect(page).to(have_text("Imported idaho.csv"))
    expect(ParseRowJob.jobs.size).to(eq(1))
    Sidekiq::Worker.drain_all
  end

  context "when families" do
    it "updates a family" do
      family = create(:family, organization: organization)
      visit "/admin/families/#{family.id}/edit"
      fill_in("Name", with: "New")
      click_on("Update Family")
      expect(page).to(have_text("Family was successfully updated."))
      expect(page).to(have_text("New"))
    end
  end
end
