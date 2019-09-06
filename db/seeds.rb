require 'faker'
User.delete_all
users = (1..100).collect {{username: Faker::Internet.username, photo: Faker::Avatar.image ,email: Faker::Internet.email}}

User.create!(users)
