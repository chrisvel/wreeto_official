puts "=> Creating default user [admin:password]"
User.create!({username: 'admin', email: 'user@email.com', password: 'password', confirmed_at: DateTime.now})
