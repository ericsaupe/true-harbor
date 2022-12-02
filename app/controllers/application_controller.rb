# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :validate_subdomain, if: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_sentry_context

  def set_sentry_context
    context = { account: request.subdomain }
    context.merge!({ id: current_user.id, email: current_user.email }) if current_user.present?
    Sentry.set_user(context)
  end

  protected

  def validate_subdomain
    unless request.subdomain.present? && Organization.find_by(subdomain: request.subdomain)
      raise ActionController::RoutingError, "Organization not found"
    end
  end

  def configure_permitted_parameters
    added_attrs = [:email, :first_name, :last_name, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end
end
