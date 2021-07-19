class Note < ApplicationRecord
  include Taggable
  include Utils::BaseConfig
  has_ancestry

  attr_accessor :new_category_id, :link_ids

  # Callbacks
  before_validation :set_defaults, if: :new_record?
  before_validation :set_guid, if: :new_record?
  
  # Associations
  belongs_to :category
  belongs_to :project, optional: true
  has_many_attached :attachments
  belongs_to :user
  has_and_belongs_to_many :digital_gardens

  # Validations
  validates :title, presence: true, allow_blank: false
  validates :category, presence: true, allow_blank: false
  validates :content, presence: true, allow_blank: true

  # Scopes
  scope :for_category, ->(slug) { eager_load(:category).where({categories: {slug: slug}}) }
  scope :search_by_keyword, ->(query) do
    where("lower(title) LIKE ?", "%#{sanitize_sql_like(query.downcase)}%") 
  end
  scope :favorites, -> { where(favorite: true) }
  scope :favorites_order, -> { order('favorite DESC, updated_at DESC') }
  # scope :favorites_order, -> { order('(case when favorite then 1 else 0 end) DESC, updated_at DESC') }

  def self.search(query)
    where("title like ? or content like ?", "%#{query}%", "%#{query}%")
  end

  enum sharestate: {
    'is_private': 0,
    'is_public': 1
  }

  def set_defaults
    self.sharestate = 'is_private'
    if category.nil? && project.nil? 
      self.category = user.categories.where(title: 'Inbox').where(slug: 'inbox')
    end
  end

  def make_public
    self.sharestate = 'is_public'
    self.save!
  end

  def make_private
    self.sharestate = 'is_private'
    self.save!
  end
  
  def link_ids 
    new_record? ? [] : descendant_ids
  end 

  def set_guid
    loop do
      self.guid = SecureRandom.uuid
      break unless Note.where(guid: self.guid).exists?
    end
  end

  def public_shared
    if sharestate == 'is_public' 
      true 
    elsif sharestate == 'is_private' 
      false
    end
  end

  def public_shared=(public_shared)
    if public_shared == '1'
      self.sharestate = :is_public 
    elsif public_shared == '0'
      self.sharestate = :is_private 
    end
  end

  def public_url
    "#{base_url}/public/#{self.guid}"
  end

  def to_param
    self.guid
  end

  def self.tagged_with(name, user_id)
    user = User.find(user_id)
    user.tags.find_by!(name: name)&.notes
end
end
