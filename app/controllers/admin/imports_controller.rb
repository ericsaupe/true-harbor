# frozen_string_literal: true

module Admin
  class ImportsController < Admin::ApplicationController
    def index
      redirect_to(new_admin_import_path)
    end

    def new; end

    def create
      current_organization = current_user.super_admin? ? Organization.find(params[:organization_id]) : organization
      begin
        CsvImporter::Idaho.import(current_organization, params[:file])
      rescue CSV::MalformedCSVError => e
        flash[:error] = e.message
        return redirect_to(new_admin_import_path)
      end
      flash[:success] = "Imported #{params[:file].original_filename}"
      redirect_to(new_admin_import_path)
    end
  end
end
