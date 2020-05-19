class AddNotesMigration < ActiveRecord::Migration[5.2]
  def change
    Inventory::Note.all.each do |note| 
      ::Note.create!(note.attributes.except(:id))
    end
  end
end
