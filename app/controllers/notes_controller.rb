# frozen_string_literal: true

class NotesController < AuthenticatedController
  def new
    @note = Note.new(noteable: noteable)
  end

  def create
    @note = Note.new(note_params)
    if @note.save
      respond_to do |format|
        format.html do
          redirect_to(
            polymorphic_path(@note.noteable),
            flash: { success: "Successfully created note." },
            status: :see_other,
          )
        end
        format.turbo_stream do
          @note = Note.new(noteable: @note.noteable)
        end
      end
    else
      render(action: "edit")
    end
  end

  private

  def note_params
    params.require(:note).permit(:content).with_defaults(user: current_user, noteable: noteable)
  end

  def noteable
    if params.include?(:family_id)
      @organization.families.find(params[:family_id])
    else
      @organization
    end
  end
end
