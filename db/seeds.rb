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