class Note < ApplicationRecord
  include Utils::BaseConfig

  attr_accessor :new_category_id, :tag_list

  # Callbacks
  before_validation :set_defaults, if: :new_record?
  before_validation :set_guid, if: :new_record?
  
  # Associations
  belongs_to :category   
  has_many :taggings #, foreign_key: 'note_id'
  has_many :tags, through: :taggings
  belongs_to :user

  # Validations
  validates :title, presence: true, allow_blank: false
  validates :category, presence: true, allow_blank: false
  validates :content, presence: true, allow_blank: false

  # Scopes
  scope :for_category, ->(slug) { eager_load(:category).where({categories: {slug: slug}}) }
  scope :search_by_keyword, ->(query) do
    where("lower(title) LIKE ?", "%#{sanitize_sql_like(query.downcase)}%") 
  end
  scope :favorites, -> { where(favorite: true) }

  def self.search(query)
    where("title like ? or content like ?", "%#{query}%", "%#{query}%")
  end

  enum sharestate: {
    'is_private': 0,
    'is_public': 1
  }

  def set_defaults
    self.sharestate = 'is_private'
  end

  def make_public
    self.sharestate = 'is_public'
    self.save!
  end

  def make_private
    self.sharestate = 'is_private'
    self.save!
  end

  def set_guid
    loop do
      self.guid = SecureRandom.uuid
      break unless Note.where(guid: self.guid).exists?
    end
  end

  def public_url
    "#{base_url}/public/#{self.guid}"
  end

  def to_param
    self.guid
  end

  def tag_list
    self.tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |name|
      Tag.where(name: name.strip, user: user).first_or_create!
    end
  end

  def self.tagged_with(id, user_id)
    user = User.find(user_id)
    tag = user.tags.find(id)
    tag.present? ? tag.notes : []
  end
end
