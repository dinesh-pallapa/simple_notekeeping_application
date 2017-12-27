class NotePermissionsController < ApplicationController
  def index
    @note_permissions = NotePermission.all
  end
  def new
    @note_permission = NotePermission.new
    @users = User.all
  end
  def create
    @note_permission = NotePermission.new(note_permission_params)
    if @note_permission.save
      flash[:notice] = "Added member to share note permission!"
      redirect_to root_path
    else

    end
  end

  private
  def note_permission_params
    params.require(:note_permission).permit(shared_user: [])
  end

end
