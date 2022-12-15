# frozen_string_literal: true

module SaveExperiences
  def save_experiences
    child_need_ids = (experiences_params[:experiences_attributes] || []).pluck(:child_need_id).compact_blank
    child_need_ids.each do |child_need_id|
      experienceable.experiences.find_or_create_by(child_need_id: child_need_id)
    end
    # Remove any old experiences that are no longer in the list
    experienceable.experiences.where.not(child_need_id: child_need_ids).destroy_all
  end

  def experienceable
    @family || @search
  end

  def experiences_params
    return params.require(:family).permit(experiences_attributes: [:child_need_id]) if params[:family]

    params.require(:search).permit(experiences_attributes: [:child_need_id]) if params[:search]
  end
end
