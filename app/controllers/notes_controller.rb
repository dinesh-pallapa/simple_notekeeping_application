class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_shared_notes
  before_action :find_note, only: [:edit, :update, :show, :destroy]

  def index
    @tag_notes_count = Tag.joins(:notes).group(:name).count
    if params[:tag]
      @notes = Note.tagged_with(params[:tag]).where(user_id: current_user.id)
    else
      @notes = current_user.notes unless current_user.nil?
    end
  end

  def new
    @note_permission = NotePermission.all.where.not(shared_user: current_user.email)
    @note = current_user.notes.build
  end

  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      flash[:notice] = "note created Successfully"
      redirect_to note_path(@note)
    else
      flash[:alert] = "title can't be blank"
      redirect_to new_note_path
    end
  end

  def show
    @tag_notes_count = Tag.joins(:notes).group(:name).count
    @note_access = @shared_notes.any? {|note|  note.id == @note.id } if !@shared_notes.nil?
    if !@note_access && (@note.user_id != current_user.id)
      flash[:alert] = "You didn't have permission to access this note"
      redirect_to root_path
    end
  end

  def edit
    @note_permission = NotePermission.all.where.not(shared_user: current_user.email)
    @note_access = @shared_notes.any? {|note|  note.id == @note.id } if !@shared_notes.nil?
    if !@note_access && (@note.user_id != current_user.id)
      flash[:notice] = "You didn't have permission to edit"
      redirect_to note_path
    end
  end

  def update
    if @note.user_id != current_user.id
      flash[:alert] = "You can only edit your own notes."
      redirect_to root_path
    elsif @note.update_attributes(note_params)
      flash[:notice] = "note Successfully updated"
      redirect_to note_path(@note)
    else
      flash[:alert] = "Error updating note!"
      render :edit
    end
  end

  def destroy
    if @note.destroy
      flash[:notice] = "note Successfully deleted"
      redirect_to root_path
    else
      flash[:alert] = "Error updating note"
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :description, :all_tags, {tag_ids:[]}, {note_permission_ids: []})
  end

  def find_note
    @note = Note.find(params[:id])
  end
  def find_shared_notes
    @shared_user = NotePermission.find_by_shared_user(current_user.email)
    @shared_notes = @shared_user.notes if !@shared_user.nil?
  end
end
