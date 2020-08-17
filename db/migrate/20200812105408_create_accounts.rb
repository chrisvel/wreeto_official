class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.boolean :wiki_enabled
      t.boolean :attachments_enabled
    end
  end
end
