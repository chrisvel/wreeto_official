class Category < ApplicationRecord

  before_update  :protect_unchangeables
  before_validation  :set_slug

  has_many :subcategories, class_name: 'Category', foreign_key: "parent_id", dependent: :destroy
  has_many :projects, class_name: 'Project', foreign_key: "parent_id", dependent: :destroy
  has_many :notes, class_name: 'Note'
  belongs_to :parent, class_name: 'Category', optional: true
  belongs_to :user

  validates :title, presence: true, allow_blank: false, uniqueness: {scope: [:user_id, :parent_id]}
  validates :parent, presence: true, allow_blank: true
  validate  :slug_is_unique, if: :slug_changed?

  scope :ordered_by_title, -> { order('title ASC') }
  scope :parents_ordered_by_title, -> { where(parent: nil).order('title ASC') }
  scope :inbox, -> { find_by(title: 'Inbox', slug: 'inbox') }
  scope :all_but_inbox, -> { where.not(title: 'Inbox', slug: 'inbox') }
  scope :generic, -> { where(type: nil) }

  def full_title
    return self.title if self.parent.nil?
    "#{self.parent.title} :: #{self.title}"
  end

  def subcategories_notes
    self.subcategories.map{|a| a.notes}.flatten
  end

  def items_amount
    itcat = self.notes.count || 0
    itsub = self.subcategories.map{|a| a.notes.count}.inject(:+) || 0
    itcat + itsub
  end

  def is_a_category?
    type.nil?
  end

  def is_a_project? 
    type == 'Project'
  end

  def is_inbox? 
    title == 'Inbox' && slug == 'inbox'
  end

  def to_param
    self.slug
  end

  def slug_is_unique
    slugged = user.categories.find_by(slug: slug)
    unless slugged.nil?
      errors.add(:title, "translates to a url slug <strong>#{slugged.slug}</strong> that is being used in this category. Please remove extra spaces and symbols and try again")
    end
  end

  def dg_notes
    notes.where(dg_enabled: true).order(title: :asc)
  end

  private

  def set_slug
    if parent.present?
      if parent.parent.present? 
        self.slug = parent.parent.title.parameterize + '_' + parent.title.parameterize + '_' + title.parameterize
      else 
        self.slug = parent.title.parameterize + '_' + title.parameterize
      end
    else 
      self.slug = title.parameterize
    end
  end

  def protect_unchangeables
    unless self.deletable
      raise ActiveRecord::ReadOnlyRecord
      errors.add(:base, "cannot change #{self.title} category")
    end
  end
end
