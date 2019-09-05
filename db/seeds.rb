require 'faker'
User.delete_all
Business.delete_all
users = (1..100).collect {{username: Faker::Internet.username, photo: Faker::Avatar.image ,email: Faker::Internet.email}}

businesses = (1..100).collect {{name: Faker::Restaurant.name, photo: Faker::Avatar.image}}

User.create!(users)
Business.create!(businesses)