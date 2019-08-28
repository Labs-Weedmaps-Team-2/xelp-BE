require 'faker'

users = Array.new(100) { |e| e = {username: Faker::Internet.username, photo: Faker::Avatar.image ,email: Faker::Internet.email} }

User.create!(users)
