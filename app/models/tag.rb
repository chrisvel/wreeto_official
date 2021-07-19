class Tag < ApplicationRecord

  # Associations
  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :notes, through: :taggings, source: :taggable, source_type: 'Note'

  before_validation :sanitize_name

  default_scope { ordered_by_name }
  scope :ordered_by_name, -> { order('name ASC') }

  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9\_\-]+\z/i , message: "can only contain letters, numbers, underscores and dashes"}, uniqueness: { scope: [:user], case_sensitive: false }

  def notes_amount 
    self.notes.count 
  end

  private 

  def sanitize_name 
    self.name = name.underscore
  end
end
