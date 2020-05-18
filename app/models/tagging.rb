class Tagging < ApplicationRecord
  belongs_to :inventory_item, foreign_key: 'inventory_item_id', class_name: "Inventory::Item"
  belongs_to :tag
end
