class BackfillAccount < ActiveRecord::Migration[5.2]
  def change
    if User.any?
      account = Account.first_or_create!
      User.update_all(account_id: account.id)
    end
  end
end
