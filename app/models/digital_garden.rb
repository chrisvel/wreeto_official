class DigitalGarden < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :notes

  before_validation :set_slug

  # TODO: Improve validation message
  validates :title, presence: true, allow_blank: false, format: { with: /\A[a-zA-Z0-9\_\-\s\,]+\z/i , message: "can contain only letters and numbers"}, uniqueness: true
  validate  :slug_is_unique

  scope :enabled, -> { where(enabled: true) }

  def enabled_notes 
    notes.includes(:category).where(dg_enabled: true).order(title: :asc)
  end

  def categories 
    cats = {par: [], sub: []}
    enabled_notes.map do |note|
      category = note.category
      parent = note.category.parent
      if parent.present? 
        cats[:par] << parent 
        cats[:sub] << category
      else 
        cats[:par] << category
      end
    end
    cats[:par].uniq!
    cats[:sub].uniq!
    cats
  end

  def parents 
    categories[:par].sort_by(&:title)
  end

  def subcategories 
    categories[:sub].sort_by(&:title)
  end

  def to_param
    slug
  end

  private

  def slug_is_unique
    slugged = DigitalGarden.find_by(slug: slug)
    if slugged.present? && slugged.slug != slug
      errors.add(:title, "translates to a url slug <strong>#{slugged.slug}</strong> that is being used. Please remove extra spaces and symbols and try again or try a different name")
    end
  end

  def set_slug
    self.slug = title.parameterize
  end
end
