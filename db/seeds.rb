# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Plan.create!(
  slug: 'trial',
  name: 'Trial'
)

user = User.first_or_create!({
  firstname: 'John', 
  lastname: "Johnnson", 
  email: 'user@email.com', 
  password: 'password', 
  add_ons: ["digital_gardens", "attachments", "backlinks", "graph", "wiki", "inbox"]})
user.confirm

category = user.categories.find_or_create_by!(title: 'Programming')
['Ruby', 'Python', 'C++', 'Java', 'JavaScript', 'Swift', 'Kotlin', 'Rust', 'Ruby on Rails'].each do |c| 
  user.categories.find_or_create_by!(title: c, parent: category)
end

category = user.categories.find_or_create_by!(title: 'Star Wars')
100.times do 
  user.notes.create!(category: category, title: Faker::Movies::StarWars.character, content: Faker::Movies::BackToTheFuture.quote)
end

category = user.categories.find_or_create_by!(title: 'Back To The Future')
100.times do 
  user.notes.create!(category: category, title: Faker::Movies::BackToTheFuture.character, content: Faker::Movies::BackToTheFuture.quote)
end

user.digital_gardens.find_or_create_by!(title: 'CodeGarden', enabled: true)

