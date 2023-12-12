crumb :posts do
  link "投稿一覧", posts_path
end

crumb :posts_show do |post|
  link "#{post.music_name}の投稿", post_path(post)
  parent :posts
end

crumb :posts_new do
  link "新規投稿", new_post_path
  parent :posts
end

crumb :posts_edit do |post|
  link "#{post.music_name}の投稿編集", edit_post_path(post)
  parent :posts_show, post
end

crumb :posts_memory do
  link "思い出一覧", memory_index_posts_path
  parent :posts
end

crumb :user_sessions_new do
  link "ログイン", login_path
  parent :posts
end

crumb :users_new do
  link "新規登録", signup_path
  parent :posts
end

crumb :users_show do |user|
  link "#{user.name}さんの詳細ページ", user_path(user)
  parent :posts
end

crumb :profiles do
  link "マイページ", profile_path
  parent :posts
end

crumb :profiles_follows do
  link "フォロー一覧", follows_profile_path
  parent :profiles
end

crumb :profiles_followers do
  link "フォロワー一覧", followers_profile_path
  parent :profiles
end

crumb :profiles_edit do
  link "プロフィール編集", edit_profile_path
  parent :profiles
end

crumb :profiles_likes do
  link "いいねした投稿一覧", likes_profile_path
  parent :profiles
end

crumb :profiles_my_posts do
  link "あなたの投稿", my_posts_profile_path
  parent :profiles
end

crumb :rooms_index do
  link "チャットルーム一覧", rooms_path
  parent :profiles
end

crumb :rooms_show do |room|
  user_rooms = room.user_rooms
  user_rooms.each do |ur|
    if ur.user_id != current_user.id
      user = User.find(ur.user.id)
      link "#{user.name}さんのチャットルーム", room_path(room.id)
      parent :rooms_index
    end
  end
end

crumb :prefectures_show do |prefecture|
  link "#{prefecture.name}の投稿一覧", prefecture_path(prefecture.id)
  parent :posts
end

crumb :notifications do
  link "新規通知一覧", notifications_path
  parent :posts
end

crumb :notifications_already_read do
  link "既読通知一覧", already_read_notifications_path
  parent :notifications
end


