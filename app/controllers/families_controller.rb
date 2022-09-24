# frozen_string_literal: true

class FamiliesController < AuthenticatedController
  include FormatSerializedFields

  before_action :find_family, only: [:show, :edit, :update, :destroy]

  def index
    @families = Family.all.order(:id)
  end

  def show; end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    if @family.save
      redirect_to(@family, flash: { success: "Successfully created family." }, status: :see_other)
    else
      render(action: "new")
    end
  end

  def edit; end

  def update
    if @family.update(family_params)
      respond_to do |format|
        format.html do
          redirect_to(edit_family_path(@family), flash: { success: "Successfully updated family." }, status: :see_other)
        end
        format.json { render(json: @family) }
      end
    else
      render(action: "edit")
    end
  end

  def destroy
    family.destroy
    redirect_to(families_url, flash: { success: "Successfully destroyed family." }, status: :see_other)
  end

  private

  def find_family
    @family ||= Family.find(params[:id])
  end

  def family_params
    allowed_params = params.require(:family).permit(:name, :address_1, :address_2, :city, :state, :zip, :phone, :email,
      :region, :license_date, :status, :race, :religion, :family_interest, :other_children_in_home, :spots_available,
      :icwa, :dogs, :cats, :other_animals, :available_visit_transportation, :available_school_transportation,
      :available_counselor_transportation, :available_multiple_appointments_per_week,
      :last_contacted_at, experience_with_care: {}, recreational_activities: {}, skills: {})
    format_serialized_fields(allowed_params)
  end
end
