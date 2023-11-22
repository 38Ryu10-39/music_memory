require 'rails_helper'

RSpec.fdescribe "Notifications", js: true, type: :system do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  before { login(user1) }
  context '通知がない時' do
    it 'ベルマークを押すと通知一覧ページへ' do
      find('a .fa-bell').click
      expect(current_path).to eq notifications_path
    end
    it '通知がない時通知はないメッセージ' do
      visit notifications_path
      expect(page).to have_content(I18n.t('defaults.messages.no_notification'))
    end
  end
  context '通知がある時' do
    let!(:post) { create(:post, user_id: user1.id) }
    let!(:comment1) { create(:comment, post_id: post.id, user_id: user1.id)}
    let!(:comment2) { create(:comment, post_id: post.id, user_id: user2.id, body: "こめんと")}
    let!(:like) { create(:like, post_id: post.id, user_id: user2.id)}
    let!(:follow) { create(:relationship, follower_id: user2.id, followed_id: user1.id)}
    before do
      visit notifications_path
    end
    it 'チェックマークを押すと消える' do
      find("#js-notification-#{comment2.notification.id} .fa-check").click
      expect(page).to_not have_content(comment2.body)
    end
    it '全て既読にするを押すと消える' do
      find_link(I18n.t('notifications.index.all_read')).click
      expect(page).to have_content(I18n.t('defaults.messages.no_notification'))
    end
    it '全て既読にすると既読通知済み通知一覧へ移動' do
      find_link(I18n.t('notifications.index.all_read')).click
      expect(page).to_not have_content(comment2.body)
      find_link(I18n.t('notifications.already_read.title')).click
      expect(page).to have_content(comment2.body)
    end
    it '既読済み通知一覧で通知を全削除可能' do
      find_link(I18n.t('notifications.index.all_read')).click
      find_link(I18n.t('notifications.already_read.title')).click
      find_link(I18n.t('notifications.already_read.destroy_already_read')).click
      expect(page).to have_content(I18n.t('defaults.messages.no_notification'))
    end
  end
  describe '通知が送られるか' do
    let!(:post) { create(:post, user_id: user1.id) }
    let!(:comment1) { create(:comment, post_id: post.id, user_id: user1.id, body: "あああああ")}
    let!(:comment2) { create(:comment, post_id: post.id, user_id: user2.id, body: "こめんと")}
    let!(:like) { create(:like, post_id: post.id, user_id: user2.id)}
    let!(:follow) { create(:relationship, follower_id: user2.id, followed_id: user1.id)}
    before do
      visit notifications_path
    end
    it '自身の投稿へ自身が投稿しても通知されない' do
      expect(page).to_not have_content(comment1.body)
    end
    it '自身の投稿へ他のユーザーからのコメントで通知が送られる' do
      expect(page).to have_content(comment2.body)
    end
    it 'フォローした時に通知が送られる' do
      expect(page).to have_content("あなたをフォローをしました")
    end
    it 'いいねした時に通知が送られる' do
      expect(page).to have_content("音楽の投稿にいいねをしました")
    end
  end
end
