Users
User.create!(name:  "Example User",
             last_name: "Pete",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated:    true,
             activated_at: Time.zone.now)
99.times do |n|
  first_name  = Faker::Name.name
  last_name   = Faker::Name.last_name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  first_name,
               last_name: last_name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated:    true,
               activated_at: Time.zone.now)  
end

# Microposts
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  activity = Faker::Lorem.sentence(3)
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }