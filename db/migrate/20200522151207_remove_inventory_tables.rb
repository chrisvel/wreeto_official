class RemoveInventoryTables < ActiveRecord::Migration[5.2]
  def change
    remove_index :taggings, name: "index_taggings_on_inventory_note_id"
    remove_foreign_key :taggings, :inventory_notes
    remove_column :taggings, :inventory_note_id
    drop_table :inventory_notes
    drop_table :inventory_items
  end
end
