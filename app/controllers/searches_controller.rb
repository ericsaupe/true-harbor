# frozen_string_literal: true

class SearchesController < AuthenticatedController
  include FormatSerializedFields
  include SaveExperiences

  before_action :find_search,
    only: [:show, :edit, :update, :destroy, :complete, :reopen, :download_results, :search_families]

  def index
    all_searches = @organization.searches.all.order(created_at: :desc)
    @searches_not_completed = all_searches.not_completed
    @searches = all_searches.page(params[:page])
  end

  def show
    @results = if @search.completed? || params[:include_exclusions] == "true"
      @search.results.includes(:family)
    else
      @search.results_without_exclusions
    end.order(score: :desc, created_at: :desc)
    @paginated_results = @results.page(params[:page])
  end

  def new
    @search = @organization.searches.new
  end

  def edit; end

  def create
    @search = @organization.searches.new(search_params)
    if @search.save
      save_experiences
      redirect_to(@search, flash: { success: "Successfully created search." }, status: :see_other)
    else
      flash[:error] = @search.errors.full_messages.to_sentence
      render(action: "new")
    end
  end

  def update
    if @search.update(search_params)
      save_experiences
      respond_to do |format|
        format.html do
          redirect_to(search_path(@search), flash: { success: "Successfully updated search." }, status: :see_other)
        end
        format.json { render(json: @search) }
      end
    else
      flash[:error] = @search.errors.full_messages.to_sentence
      render(action: "edit")
    end
  end

  def destroy
    @search.destroy
    redirect_to(searches_path, flash: { success: "Successfully destroyed search." }, status: :see_other)
  end

  def complete
    @search.update(completed_at: Time.current)
    redirect_to(search_path(@search), flash: { success: "Successfully finished search." }, status: :see_other)
  end

  def reopen
    @search.update(completed_at: nil)
    redirect_to(search_path(@search), flash: { success: "Successfully reopened search." }, status: :see_other)
  end

  def download_results
    only_selected = ActiveModel::Type::Boolean.new.cast(params[:only_selected]) || false
    send_data(ResultsCsvGenerator.generate_csv(search: @search, only_selected: only_selected),
      filename: "#{@search.name} results.csv",
      type: "text/csv")
  end

  def search_families
    @q = @organization.families.ransack(params[:q])
    @families = @q.result(distinct: true).includes(:searches).order(:name)
    render(partial: "family_search_result", collection: @families, as: :family, locals: { search: @search })
  end

  private

  def find_search
    @search ||= @organization.searches.includes(:child_needs).find(params[:id])
  end

  def search_params
    allowed_params = params.require(:search).permit(:name, :category, query: {},
      children_attributes: [:id, :gender, :age, :_destroy])
    allowed_params[:query] = format_serialized_fields(allowed_params[:query])
    allowed_params[:query][:region_id] =
      @organization.regions.where(id: allowed_params[:query][:region_id]&.keys).pluck(:id)
    allowed_params[:query][:school_district_id] =
      @organization.school_districts.where(id: allowed_params[:query][:school_district_id]&.keys).pluck(:id)
    allowed_params
  end
end
