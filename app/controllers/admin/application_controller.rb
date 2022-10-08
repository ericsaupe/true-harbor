# frozen_string_literal: true

# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin

    def authenticate_admin
      redirect_to(root_path, alert: "Not authorized.") unless current_user.admin?
    end

    def current_ability
      @_current_ability ||= Ability.new(current_user)
    end

    def authorized_action?(resource, action)
      current_ability.can?(action.to_sym, resource)
    end

    def scoped_resource
      if current_user.super_admin?
        resource_class
      else
        resource_class.accessible_by(current_ability)
      end
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
