# frozen_string_literal: true

module Admin
  class ImportsController < Admin::ApplicationController
    def index
      redirect_to(new_admin_import_path)
    end

    def new; end

    def create
      organization = current_user.super_admin? ? Organization.find(params[:organization_id]) : current_user.organization
      CsvImporter::Idaho.import(organization, params[:file])
      flash[:success] = "Imported #{params[:file].original_filename}"
      redirect_to(new_admin_import_path)
    end
  end
end
