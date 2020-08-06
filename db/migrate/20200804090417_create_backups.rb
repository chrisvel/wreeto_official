class CreateBackups < ActiveRecord::Migration[5.2]
  def change
    create_table :backups do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
