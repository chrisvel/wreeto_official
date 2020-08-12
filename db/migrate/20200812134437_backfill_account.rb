class BackfillAccount < ActiveRecord::Migration[5.2]
  def change
    account = Account.create!
    User.update_all(account_id: account.id)
  end
end
