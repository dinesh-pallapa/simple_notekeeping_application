class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_note, only: [:edit, :update, :show, :destroy]

  def index
    @notes = current_user.notes unless current_user.nil?
  end

  def new
    @note = current_user.notes.build
  end

  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      flash[:notice] = "note created Successfully"
      redirect_to note_path(@note)
    else
      flash[:alert] = "Error creating new note!"
      redirect_to new_note_path
    end
  end

  def show
    if @note.user_id != current_user.id
      flash[:alert] = "You didn't have permission to access this note"
      redirect_to root_path
    end
  end

  def edit
    if @note.user_id != current_user.id
      flash[:notice] = "You didn't have permission to edit"
      redirect_to note_path
    end
  end

  def update
    if @note.update_attributes(note_params)
      flash[:notice] = "note Successfully updated"
      redirect_to note_path(@note)
    else
      flash[:alert] = "Error updating note!"
      render :edit
    end
  end

  def destroy
    if @note.delete
      flash[:notice] = "note Successfully deleted"
      redirect_to root_path
    else
      flash[:alert] = "Error updating note"
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :description, :all_tags)
  end

  def find_note
    @note = Note.find(params[:id])
  end
end
