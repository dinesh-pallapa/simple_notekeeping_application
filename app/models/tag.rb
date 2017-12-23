class Tag < ApplicationRecord

  has_many :taggings, dependent: :destroy
  has_many :notes, through: :taggings

  def self.first_or_create_with_name!(name)
    where(name: name.strip.downcase).first_or_create! do |tag|
      tag.name = name.strip
    end
  end

end
