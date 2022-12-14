# frozen_string_literal: true

# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    if Rails.env.production?
      around_action :display_errors
    end

    def authenticate_admin
      return true if current_user.admin?

      redirect_to(root_path, alert: "You are not authorized to access this page.")
    end

    def display_errors
      yield
    rescue => exception
      Sentry.capture_exception(exception)
      flash[:error] = exception.message
      redirect_back(fallback_location: admin_root_path)
    end

    # Whether the current user is authorized to perform the named action on the
    # resource.
    #
    # @param _resource [ActiveRecord::Base, Class, String, Symbol] The
    #   temptative target of the action, or the name of its class.
    # @param _action_name [String, Symbol] The name of an action that might be
    #   possible to perform on a resource or resource class.
    # @return [Boolean] `true` if the current user is authorized to perform the
    #   action on the resource. `false` otherwise.
    def authorized_action?(resource, action_name)
      can?(action_name, resource)
    end
    helper_method :authorized_action?

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end

    def scoped_resource
      resource_class.accessible_by(current_ability)
    end

    def organization
      @organization ||= if current_user.super_admin?
        Organization.find_by!(subdomain: request.subdomain)
      else
        current_user.organization
      end
    end
  end
end
