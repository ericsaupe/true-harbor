# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Admin") do
  let(:admin) { create(:admin) }
  let(:organization) { admin.organization }

  before do
    change_domain(organization.subdomain)
    sign_in(admin)
  end

  it "queues up import jobs" do
    visit "/admin/imports/new"
    attach_file("File", Rails.root.join("spec/fixtures/files/idaho.csv"))
    click_on("Save")
    expect(page).to(have_text("Imported idaho.csv"))
    expect(ParseRowJob.jobs.size).to(eq(1))
    Sidekiq::Worker.drain_all
  end
end
