puts "=> Creating default user [admin:password]"
account = Account.create!
User.create!({username: 'admin', email: 'user@email.com', password: 'password', confirmed_at: DateTime.now, account: account})
