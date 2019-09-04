require 'faker'
User.delete_all
Business.delete_all
users = (1..100).collect {{username: Faker::Internet.username, photo: Faker::Avatar.image ,email: Faker::Internet.email}}

comments = (1..100).collect {{ame: Faker::Commerce.product_name: Faker::Company.catch_phrase}}

User.create!(users)
Comment.create!(comments)