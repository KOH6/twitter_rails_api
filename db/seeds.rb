# frozen_string_literal: true

User.destroy_all

USER_COUNT = 10
POST_COUNT = 100
user_ids = []
post_ids = []

USER_COUNT.times do |n|
  count = n + 1
  user = User.new(
    name: "ユーザ名#{count}#{('a'..'z').to_a.sample(8).join}",
    user_name: "#{count}#{('a'..'z').to_a.sample(8).join}",
    email: "example#{count}@example.com",
    password: "#{'a' * count}111111",
    birthdate: '2000-01-01',
    phone: '111122223333',
    introduction: '自己紹介文です' * 20,
    place: '東京都',
    website: 'google.com'
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

  Like.create!(
    user_id: user_ids.reject { |id| id == post.user_id }.sample,
    post_id: post.id
  )
  Repost.create!(
    user_id: user_ids.reject { |id| id == post.user_id }.sample,
    post_id: post.id
  )
  rand(0..15).times do |m|
    Comment.create!(
      user_id: user_ids.reject { |id| id == post.user_id }.sample,
      post_id: post.id,
      content: "#{post.user.name}さん、投稿#{n}に対するコメント#{m}です"
    )
  end
end

user_ids.each do |user_id|
  followee_ids = user_ids.reject { |id| id == user_id }.sample(rand(USER_COUNT - 1))
  followee_ids.each { |followee_id| Follow.create!(follower_id: user_id, followee_id:) }
end
