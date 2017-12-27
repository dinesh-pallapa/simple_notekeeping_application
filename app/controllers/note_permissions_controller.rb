class NotePermissionsController < ApplicationController
  before_action :authenticate_user!
  def index
    @note_permissions = NotePermission.all
  end
  def new
    @note_permission = NotePermission.new
    @note_permission_emails = NotePermission.all.pluck(:shared_user)
    @users_emails = User.all.pluck(:email) - [current_user.email]
    @member_emails = @users_emails.compact - @note_permission_emails.compact
  end
  def create
    @note_permission = NotePermission.new(note_permission_params)
    if @note_permission.save
      flash[:notice] = "Added member to share note permission!"
      redirect_to root_path
    else
      flash[:alert] = "User can't be added"
      redirect_to new_note_permission_path
    end
  end

  private
  def note_permission_params
    params.require(:note_permission).permit(shared_user: [])
  end

end
