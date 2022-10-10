# frozen_string_literal: true

class ResultsController < AuthenticatedController
  def update
    if result.update(result_params)
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

  private

  def result
    @result ||= @organization.results.find(params[:id])
  end

  def result_params
    params.require(:result).permit(:state)
  end
end
