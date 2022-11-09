# frozen_string_literal: true

class FamiliesController < AuthenticatedController
  include FormatSerializedFields

  before_action :find_family, only: [:show, :edit, :update, :destroy, :contacted]

  def index
    @q = @organization.families.ransack(params[:q])
    @families = @q.result.includes(:region).order(:name).page(params[:page])
  end

  def show
    @search = @family.searches.find_by(id: params[:search_id])
    render(layout: false) if params[:layout] == "false"
  end

  def new
    @family = @organization.families.new
  end

  def edit; end

  def create
    @family = @organization.families.new(family_params)
    if @family.save
      redirect_to(@family, flash: { success: "Successfully created family." }, status: :see_other)
    else
      render(action: "new")
    end
  end

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

  def contacted
    if @family.update(last_contacted_at: Time.current)
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
    @family ||= @organization.families.find(params[:id])
  end

  def family_params
    allowed_params = params.require(:family).permit(:name, :address_1, :address_2, :city, :state, :zip, :email,
      :region_id, :license_date, :status, :race, :religion, :other_children_in_home, :spots_available,
      :icwa, :dogs, :cats, :other_animals, :available_visit_transportation, :available_school_transportation,
      :available_counselor_transportation, :on_break_start_date, :on_break_end_date, :last_contacted_at,
      phone: [], availability: [], experience_with_care: {}, recreational_activities: {}, skills: {},
      exclusions_attributes: [:id, :gender, :comparator, :age, :_destroy])
    format_serialized_fields(allowed_params)
    allowed_params[:region_id] = nil if @organization.regions.find_by(id: allowed_params[:region_id]).nil?
    allowed_params[:phone] = allowed_params[:phone].compact_blank
    allowed_params
  end
end
