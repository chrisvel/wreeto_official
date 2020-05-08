# Basic test stuff
User.create({firstname: 'John', lastname: "Johnnson", email: 'user@email.com', password: 'password', confirmed_at: DateTime.now})
user = User.first
user.categories.create({title: 'Projects', deletable: false})
