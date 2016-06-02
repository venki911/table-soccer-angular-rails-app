# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'net/http'

User.create!(first_name: 'Super',
               last_name: 'User',
               email: 'admin@tst.com',
               password: 'admin123',
               password_confirmation: 'admin123',
               is_admin: true,
               confirmed_at: Time.now)

50.times do |n|
  if rand(1..2) == 1
    f_name  = Faker::Name.male_first_name
    l_name = Faker::Name.male_last_name
  else
    f_name  = Faker::Name.female_first_name
    l_name = Faker::Name.female_last_name
  end

  email = "test-#{n+1}@mail.org"
  User.create!(first_name: f_name,
               last_name: l_name,
               email: email,
               password: "12345678",
               password_confirmation: "12345678",
               confirmed_at: Time.zone.now)
end

users = User.all
users.each do |user|
  rank = Random.new
  user.rank = rank.rand(900..1100)
  user.save
end

4.times do |i|
  tournament = Tournament.create!(name: "Тестовый турнир № #{i+1}", tourn_type: 3,
  place: 'Третий этаж', datetime: Time.zone.now + (20+(i+1)).days)
  Team.generate_teams_automatically(User.all.sample(18/(i+1)), tournament.id)
  tournament.create_matches(rand(1..3), {tournament_id: tournament.id, tour: (i+1)})
end
