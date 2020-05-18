# == Schema Information
#
# Table name: inventory_items
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  type        :string
#  user_id     :integer
#  title       :string
#  content     :text
#  category_id :integer
#  favorite    :boolean
#  serial_no   :string
#  images      :string
#  sharestate  :integer
#  guid        :string
#

module Inventory
  class Note < Inventory::Item
    include Utils::BaseConfig
    
    attr_accessor :new_category_id

    # Callbacks
    before_validation :set_defaults, if: :new_record?
    before_validation :set_guid, if: :new_record?
    
    # Associations
    belongs_to :category   

    # Validations
    validates :title, presence: true, allow_blank: false
    validates :category, presence: true, allow_blank: false

    # Scopes
    scope :for_category, ->(slug) { eager_load(:category).where({categories: {slug: slug}}) }
    scope :search_by_keyword, ->(query) do
      where("lower(title) LIKE ?", "%#{sanitize_sql_like(query.downcase)}%") 
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
        break unless Inventory::Note.where(guid: self.guid).exists?
      end
    end

    def public_url
      "#{base_url}/public/#{self.guid}"
    end

    def to_param
      self.guid
    end

    def all_tags=(names)
      self.tags = names.split(",").map do |name|
        Tag.where(name: name.strip).first_or_create!
      end
    end
    
    def all_tags
      self.tags.map(&:name).join(", ")
    end

    def self.tagged_with(name)
      Tag.find_by_name!(name).inventory_notes
    end
  end
end
