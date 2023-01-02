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

    it "renders the average yes stat" do
      yes_search = create(:search, organization: organization, completed_at: Time.zone.now)
      create(:result, search: yes_search, state: "selected")
      no_search = create(:search, organization: organization, completed_at: Time.zone.now)
      create(:result, search: no_search, state: "declined")
      not_finished_search = create(:search, organization: organization)
      create(:result, search: not_finished_search)

      visit("/analytics")
      expect(page).to(have_content("Average Yes's per Search"))
      within("#average-yes-per-search") do |element|
        expect(element).to(have_content("0.5"))
      end
    end

    it "renders the average no stat" do
      no_search = create(:search, organization: organization, completed_at: Time.zone.now)
      create(:result, search: no_search, state: "declined")
      no_search = create(:search, organization: organization, completed_at: Time.zone.now)
      create(:result, search: no_search, state: "declined")
      yes_search = create(:search, organization: organization, completed_at: Time.zone.now)
      create(:result, search: yes_search, state: "selected")

      visit("/analytics")
      expect(page).to(have_content("Average No's per Search"))
      within("#average-no-per-search") do |element|
        expect(element).to(have_content("0.67"))
      end
    end

    it "renders the average time stat" do
      Timecop.freeze do
        create(:search, organization: organization, created_at: 1.day.ago, completed_at: 1.day.ago + 10.minutes)
        create(:search, organization: organization, created_at: 1.day.ago, completed_at: 1.day.ago + 20.minutes)
      end

      visit("/analytics")
      expect(page).to(have_content("Average Complete Time"))
      within("#average-time-per-search") do |element|
        expect(element).to(have_content("15 minutes"))
      end
    end

    describe "timeframe" do
      around do |example|
        Timecop.freeze(Time.zone.local(2022, 9, 1, 12, 0, 0)) do
          create(:search, organization: organization, created_at: 1.year.ago, completed_at: 1.year.ago + 30.minutes)
          create(:search, organization: organization, created_at: 1.year.ago, completed_at: 1.year.ago + 30.minutes)
          create(:search, organization: organization, created_at: 8.days.ago, completed_at: 8.days.ago + 20.minutes)
          create(:search, organization: organization, created_at: 8.days.ago, completed_at: 8.days.ago + 20.minutes)
          create(:search, organization: organization, created_at: 1.day.ago, completed_at: 1.day.ago + 10.minutes)
          create(:search, organization: organization, created_at: 1.day.ago, completed_at: 1.day.ago + 10.minutes)
          example.run
        end
      end

      it "renders the average time stat for the last 7 days" do
        visit("/analytics")
        expect(page).to(have_content("Average Complete Time"))
        within("#average-time-per-search") do |element|
          expect(element).to(have_content("20 minutes"))
        end
        select("Last 7 Days", from: "timeframe")
        within("#average-time-per-search") do |element|
          expect(element).to(have_content("10 minutes"))
        end
      end

      it "renders the average time stat for the year to date" do
        visit("/analytics")
        expect(page).to(have_content("Average Complete Time"))
        within("#average-time-per-search") do |element|
          expect(element).to(have_content("20 minutes"))
        end
        select("Year to Date", from: "timeframe")
        within("#average-time-per-search") do |element|
          expect(element).to(have_content("15 minutes"))
        end
      end

      it "renders the average time stat for all time" do
        visit("/analytics")
        expect(page).to(have_content("Average Complete Time"))
        within("#average-time-per-search") do |element|
          expect(element).to(have_content("20 minutes"))
        end
        select("Last 7 Days", from: "timeframe")
        within("#average-time-per-search") do |element|
          expect(element).to(have_content("10 minutes"))
        end
        select("All Time", from: "timeframe")
        within("#average-time-per-search") do |element|
          expect(element).to(have_content("20 minutes"))
        end
      end
    end
  end
end
