class NotePermission < ApplicationRecord
  has_and_belongs_to_many :notes

  before_save do
    self.shared_user.gsub!(/[\[\]\"]/, "") if attribute_present?("shared_user")
  end

end
