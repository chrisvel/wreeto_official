# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  parent_id   :integer
#  active      :boolean          default(TRUE), not null
#  deletable   :boolean          default(TRUE), not null
#  slug        :string
#

class Category < ApplicationRecord

  before_update  :protect_unchangeables
  before_validation  :set_slug

  has_many :subcategories, class_name: 'Category', foreign_key: "parent_id", dependent: :destroy
  has_many :notes, class_name: 'Note'
  belongs_to :parent, class_name: 'Category', optional: true
  belongs_to :user

  validates :title, presence: true, allow_blank: false, uniqueness: {scope: [:user_id, :parent_id]}
  validates :parent, presence: true, allow_blank: true
  validate  :slug_is_unique, if: :slug_changed?

  scope :ordered_by_title, -> { order('title ASC') }
  scope :ordered_by_active, -> { order('active = true DESC') }
  scope :projects, -> { where(parent: where(title: 'Projects', deletable: false)) }
  scope :active, -> { where(active: true) }
  scope :parents_ordered_by_title, -> { where(parent: nil).order('title ASC') }

  def full_title
    return self.title if self.parent.nil?
    "#{self.title} (#{self.parent.title})"
  end

  def active?
    self.active
  end

  def inactive?
    active? ? false : true
  end

  def subcategories_notes
    self.subcategories.includes([:notes]).map{|a| a.notes}.flatten
  end

  def items_amount
    itcat = self.notes.count || 0
    itsub = self.subcategories.map{|a| a.notes.count}.inject(:+) || 0
    itcat + itsub
  end

  def is_a_project?
    self.parent_id.present? && parent.slug == 'projects' && parent.title == 'Projects'
  end

  def projects? 
    slug == 'projects' && title == 'Projects'
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

  private

  def set_slug
    if parent.present?
      self.slug = parent.title.parameterize + '_' + title.parameterize
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
