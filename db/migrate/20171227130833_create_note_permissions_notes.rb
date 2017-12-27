class CreateNotePermissionsNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :note_permissions_notes do |t|
      t.integer :note_permission_id
      t.integer :note_id
    end
  end
end
