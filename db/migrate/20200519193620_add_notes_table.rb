class AddNotesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.string :title
      t.text :content
      t.boolean :favorite
      t.string :serial_no
      t.string :images
      t.integer :sharestate
      t.string :guid

      t.index :guid, unique: true

      t.timestamps
    end

    add_reference :taggings, :note, foreign_key: true
  end
end
