# frozen_string_literal: true

class ResultsController < AuthenticatedController
  def create
    @search = @organization.searches.find(params[:search_id])
    @result = @search.results.new(create_params)
    if @result.save
      respond_to do |format|
        format.html do
          redirect_to(search_path(@result.search), flash: { success: "Successfully created result." },
            status: :see_other)
        end
        format.json { render(json: @result) }
      end
    else
      redirect_to(search_path(@search), flash: { error: @result.errors.full_messages.to_sentence }, status: :see_other)
    end
  end

  def update
    if result.update(update_params)
      respond_to do |format|
        format.html do
          redirect_to(search_path(result.search), flash: { success: "Successfully updated result." },
            status: :see_other)
        end
        format.json { render(json: result) }
      end
    else
      redirect_to(search_path(result.search), flash: { error: result.errors.full_messages.to_sentence },
        status: :see_other)
    end
  end

  def destroy_by_family
    @result = @organization.results.find_by(family_id: params[:family_id], search_id: params[:search_id])
    @result&.destroy
    respond_to do |format|
      format.html do
        redirect_to(search_path(@result.search), flash: { success: "Successfully destroyed result." },
          status: :see_other)
      end
      format.json { render(json: @result) }
    end
  end

  def contacted
    if result.contacted
      respond_to do |format|
        format.html do
          redirect_to(search_path(result.search), flash: { success: "Successfully marked result as contacted." },
            status: :see_other)
        end
        format.json { render(json: result) }
      end
    else
      redirect_to(search_path(result.search), flash: { error: result.errors.full_messages.to_sentence },
        status: :see_other)
    end
  end

  private

  def result
    @result ||= @organization.results.find(params[:id])
  end

  def create_params
    params.require(:result).permit(:family_id, :state)
  end

  def update_params
    params.require(:result).permit(:state)
  end
end
