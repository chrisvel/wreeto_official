class Tag < ApplicationRecord

  # Associations
  belongs_to :user
  has_many :taggings
  has_many :notes, through: :taggings

  scope :ordered_by_name, -> { order('name ASC') }

  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9\_\-]+\z/i , message: "can contain only letters and numbers"}, uniqueness: { case_sensitive: false }

  def notes_amount 
    self.notes.count 
  end
end
