class Tag < ApplicationRecord

  # Associations
  belongs_to :user
  has_many :taggings
  has_many :notes, through: :taggings

  scope :ordered_by_name, -> { order('name ASC') }

  def notes_amount 
    self.notes.count 
  end
end
