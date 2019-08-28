require 'faker'

users = (1..100).collect {{username: Faker::Internet.username, photo: Faker::Avatar.image ,email: Faker::Internet.email}}

businesses = (1..100).collect {{name: Faker::Restaurant.name, photo: Faker::Avatar.image, type: "Bar", description: Faker::Restaurant.description, review: Faker::Restaurant.review}}

User.create!(users)
