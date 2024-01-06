# frozen_string_literal: true

User.destroy_all

USER_COUNT = 5
POST_COUNT = 50
user_ids = []
post_ids = []

USER_COUNT.times do |n|
  count = n + 1
  user = User.new(
    name: "ユーザ名#{count}",
    user_name: "#{count}#{('a'..'z').to_a.shuffle[0..7].join}",
    email: "example#{count}@example.com",
    password: "#{'a' * count}111111",
    birthdate: '2000-01-01',
    phone: '111122223333'
  )
  user.skip_confirmation!
  user.save!
  user_ids << user.id
end

POST_COUNT.times do |n|
  post = Post.create!(
    user_id: user_ids.sample,
    content: "テスト投稿#{n}です。\nテスト投稿#{n}です。\nテスト投稿#{n}です。"
  )
  post_ids << post.id
end
