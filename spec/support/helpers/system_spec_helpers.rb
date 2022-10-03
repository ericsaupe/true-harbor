# frozen_string_literal: true

module SystemSpecHelpers
  def change_domain(subdomain)
    Capybara.app_host = "http://#{subdomain}.lvh.me"
  end

  def sign_in(user)
    visit(new_user_session_path)
    fill_in("Email", with: user.email)
    fill_in("Password", with: user.password)
    click_on("Sign in")
  end
end
