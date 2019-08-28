require 'faker'

users = (1..100).collect {{username: Faker::Internet.username, photo: Faker::Avatar.image ,email: Faker::Internet.email}}

businesses = (1..100).collect {{name: Faker::Resturant.name, photo: Faker::Avatar.image, type: "Bar", description: Faker::Resturant.description, review: Faker::Resturant.review}}

User.create!(users)
