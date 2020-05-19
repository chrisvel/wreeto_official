class Tagging < ApplicationRecord
  belongs_to :note, foreign_key: 'note_id', class_name: "Note"
  belongs_to :tag
end
