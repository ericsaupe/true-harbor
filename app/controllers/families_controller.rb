# frozen_string_literal: true

class FamiliesController < AuthenticatedController
  before_action :find_family, only: [:show, :edit, :update, :destroy]

  def index
    @families = Family.all
  end

  def show; end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    if @family.save
      redirect_to(@family, notice: "Successfully created family.")
    else
      render(action: "new")
    end
  end

  def edit; end

  def update
    if @family.update(family_params)
      redirect_to(@family, notice: "Successfully updated family.")
    else
      render(action: "edit")
    end
  end

  def destroy
    family.destroy
    redirect_to(families_url, notice: "Successfully destroyed family.")
  end

  private

  def find_family
    @family ||= Family.find(params[:id])
  end

  def family_params
    params.require(:family).permit(:name, :address_1, :address_2, :city, :state, :zip, :phone, :email, :region,
      :license_date, :status, :race, :religion, :family_interest, :other_children_in_home, :spots_avialable, :icwa,
      :dogs, :cats, :other_animals, :available_visit_transportation, :available_school_transportation,
      :available_counselor_transportation, :available_multiple_appointments_per_week, :recreational_activities,
      :skills, :experience_with_care)
  end
end
