# frozen_string_literal: true

class AuthenticatedController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization_and_redirect_if_needed

  def set_organization_and_redirect_if_needed
    @organization = current_user.organization

    if request.subdomain != @organization.subdomain && !current_user.super_admin?
      url = if request.subdomain.present?
        request.url.sub(request.subdomain, @organization.subdomain)
      else
        request.url.sub("//", "//#{@organization.subdomain}.")
      end

      redirect_to(url, allow_other_host: true)
    end
  end
end
