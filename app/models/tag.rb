class Tag < ApplicationRecord

    # Associations
    has_many :taggings
    has_many :inventory_items, through: :taggings
end
