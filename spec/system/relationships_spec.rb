require 'rails_helper'

RSpec.fdescribe "Relationships",js: true, type: :system do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:follow1) { create(:relationship, follower_id: user3.id, followed_id: user2.id)}
  let!(:follow2) { create(:relationship, follower_id: user2.id, followed_id: user3.id)}
  describe '他のユーザーの詳細ページのフォロー状況' do
    context 'ログインしている時' do
      before do
        login(user1)
      end
      context '相手をフォローしている時' do
        let!(:myfollow) { create(:relationship, follower_id: user1.id, followed_id: user2.id)}
        before { visit user_path(user2) }
        it 'フォローを外すボタンが表示される' do
          expect(page).to have_content(I18n.t('users.show.unfollow'))
          expect(page).to have_selector("#js-follow-button-#{user2.id} a")
        end
        it 'フォロワー数がボタンを押すと1減る' do
          expect(page).to have_content("フォロワー数: 2")
          find("#js-follow-button-#{user2.id} a").click
          expect(page).to have_content("フォロワー数: 1")
        end
      end
      context '相手をフォローしていない時' do
        before { visit user_path(user2) }
        it 'フォローするボタンが表示される' do
          expect(page).to have_content(I18n.t('users.show.follow'))
          expect(page).to have_selector("#js-follow-button-#{user2.id} a")
        end
        it 'フォロワー数がボタンを押すと1減る' do
          expect(page).to have_content("フォロワー数: 1")
          find("#js-follow-button-#{user2.id} a").click
          expect(page).to have_content("フォロワー数: 2")
        end
      end
    end
  end
  fdescribe '自身のユーザー詳細ページのフォロー状況' do
    before do
      login(user1)
      visit user_path(user1)
    end
    it 'フォロー数、フォロワー数が表示される' do
      expect(page).to have_content("フォロー数:")
      expect(page).to have_content("フォロワー数:")
    end
    it 'フォローボタン、フォロワーボタンは表示されない' do
      expect(page).to_not have_content(I18n.t('users.show.follow'))
      expect(page).to_not have_content(I18n.t('users.show.unfollow'))
    end
  end
  describe '自身のマイページのフォロー状況' do
    before do
      login(user1)
      visit profile_path
    end
    it 'フォロー数、フォロワー数が表示される' do
      expect(page).to have_content("フォロー数:")
      expect(page).to have_content("フォロワー数:")
    end
    it 'フォローボタン、フォロワーボタンは表示されない' do
      expect(page).to_not have_content(I18n.t('users.show.follow'))
      expect(page).to_not have_content(I18n.t('users.show.unfollow'))
    end
  end
end
