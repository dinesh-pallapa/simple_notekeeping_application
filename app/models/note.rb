class Note < ApplicationRecord

  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  def trim
    title.downcase.gsub(" ", "-")
  end

  def to_param
    "#{id}-#{trim}"
  end

  def with_tags(name)
    Tag.find_by!(name: name).notes
  end

  def all_tags=(names)
    self.tags = names.split(",").map do |name|
      Tag.first_or_create_with_name!(name)
    end
  end

  def all_tags
    tags.map(&:name).join(", ")
  end

end
