User.create!(   name: "Example User",
                email: "example@railstutorial.org",
                password: "foobar",
                password_confirmation: "foobar",
                admin: true)
                
99.times do |n|
#    name = Faker::Name.name
    name = Faker::StarWars.character
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
     User.create!(
        name: name,
        email: email,
        password: password,
        password_confirmation: password
     )
end

# ６人のユーザにマイクロポストを作成する
users = User.order(:created_at).take(6)
50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
end

# リレーションシップを作成する。user が 49人フォローする。38人がuserをフォローする。
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }