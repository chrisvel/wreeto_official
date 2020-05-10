class ChangeWrongIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :categories, :slug
    add_index :categories, [:slug, :user_id], unique: true
  end
end
