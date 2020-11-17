puts "=> Creating default user [admin:password]"
user = User.create!({username: 'admin', email: 'user@email.com', password: 'password', confirmed_at: DateTime.now})
account = Account.create!(user: user)
