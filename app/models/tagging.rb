class Tagging < ApplicationRecord
  belongs_to :inventory_note, foreign_key: 'inventory_note_id', class_name: "Inventory::Note"
  belongs_to :tag
end
