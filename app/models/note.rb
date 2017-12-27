class Note < ApplicationRecord

  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true

  def trim
    title.downcase.gsub(" ", "-")
  end

  def to_param
    "#{id}-#{trim}"
  end


  def all_tags=(names)
    self.tags = names.split(",").map do |name|
      Tag.first_or_create_with_name!(name)
    end
  end

  def all_tags
    tags.map(&:name).join(", ")
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).notes
  end
end
