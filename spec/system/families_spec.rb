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
end