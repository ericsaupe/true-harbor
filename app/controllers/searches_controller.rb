# frozen_string_literal: true

class SearchesController < AuthenticatedController
  include FormatSerializedFields

  before_action :find_search, only: [:show, :edit, :update, :destroy]

  def index
    @searches = @organization.searches.all
  end

  def show
    @results = @search.results.order(score: :desc).includes(:family)
  end

  def new
    @search = @organization.searches.new
  end

  def create
    @search = @organization.searches.new(search_params)
    if @search.save
      redirect_to(@search, flash: { success: "Successfully created search." }, status: :see_other)
    else
      render(action: "new")
    end
  end

  def edit; end

  def update
    if @search.update(search_params)
      respond_to do |format|
        format.html do
          redirect_to(search_path(@search), flash: { success: "Successfully updated search." }, status: :see_other)
        end
        format.json { render(json: @search) }
      end
    else
      render(action: "edit")
    end
  end

  def destroy
    search.destroy
    redirect_to(searches_url, flash: { success: "Successfully destroyed search." }, status: :see_other)
  end

  private

  def find_search
    @search ||= @organization.searches.find(params[:id])
  end

  def search_params
    allowed_params = params.require(:search).permit(:name, query: {})
    allowed_params[:query] = format_serialized_fields(allowed_params[:query])
    allowed_params
  end
end
