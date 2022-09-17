# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Home page", type: :system) do
  it "displays the home page" do
    visit "/"
    expect(page).to(have_text("True Harbor"))
  end
end
