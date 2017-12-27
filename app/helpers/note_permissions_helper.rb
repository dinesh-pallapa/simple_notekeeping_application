# Antipattern to save user to note_permissions
module NotePermissionsHelper
  def checked(area)
    @note_permission.shared_user.nil? ? false : @note_permission.shared_user.match(area)
  end
end
