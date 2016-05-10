# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


40.times do |n|
  f_name  = Faker::Name.first_name
  l_name = Faker::Name.last_name
  email = "example-#{n+1}@railstutorial.org"
  User.create!(first_name: f_name,
               last_name: l_name,
               email: email,
               password: "12345678",
               password_confirmation: "12345678")
end

users = User.all
users.each do |user|
  rank = Random.new
  user.rank = rank.rand(50..100)
  user.save
end