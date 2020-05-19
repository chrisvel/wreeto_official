class Tag < ApplicationRecord

  # Associations
  belongs_to :user
  has_many :taggings
  has_many :notes, through: :taggings
end
