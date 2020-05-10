# Basic test stuff
puts "=> Creating default user [user@email.com:password]"
User.create!({firstname: 'John', lastname: "Johnnson", email: 'user@email.com', password: 'password', confirmed_at: DateTime.now})
