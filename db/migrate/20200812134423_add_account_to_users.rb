class AddAccountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :account, foreign_key: true
  end
end
