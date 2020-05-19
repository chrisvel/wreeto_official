class Tag < ApplicationRecord

  # Associations
  belongs_to :user
  has_many :taggings
  has_many :inventory_notes, through: :taggings
end
