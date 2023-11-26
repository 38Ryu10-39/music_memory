require 'rails_helper'

RSpec.fdescribe "Profiles", type: :system do
  describe 'プロフィール詳細' do
    let!(:user1) { create(:user, x_id: '@exampleaaaaaaaaaa1') }
    context '正常系' do
      it '初期の新規登録後には最低限のもののみ表示される' do
        login(user1)
        visit profile_path
        expect(page).to have_content user1.name
        expect(page).to have_content user1.email
        expect(page).to have_content user1.gender_i18n
      end
    end
    context '異常系' do
      it 'ログインしていないとプロフィール詳細には移動できない' do
        visit profile_path
        expect(current_path).to eq login_path
      end
    end
  end

  describe 'プロフィール編集' do
    let!(:user1) { create(:user, x_id: '@exampleaaaaaaaaaa1') }
    before do
      login(user1)
      visit profile_path
      click_link I18n.t('profiles.edit.title')
    end
    context '正常系' do
      describe 'プロフィール編集後のプロフィール画面' do
        it '編集画面で記入して更新するとプロフィール画面で表示される' do
          fill_in User.human_attribute_name(:name), with: 'user2'
          fill_in User.human_attribute_name(:email), with: 'user2@example.com'
          fill_in User.human_attribute_name(:profile), with: '好きな音楽は色々。吹奏楽の曲も好きです。'
          find("#user_birthday_1i").find("option[value='1999']").select_option
          find("#user_birthday_2i").find("option[value='9']").select_option
          find("#user_gender").find("option[value='male']").select_option
          find("#user_prefecture_id").find("option[value='14']").select_option
          fill_in User.human_attribute_name(:x_id), with: '@examplebbbbbbbbb1'
          click_button I18n.t('profiles.edit.update')
          expect(current_path).to eq profile_path
          expect(page).to have_content('user2')
          expect(page).to have_content('user2')
          expect(page).to have_content('好きな音楽は色々。吹奏楽の曲も好きです。')
          expect(page).to have_content('1999/09')
          expect(page).to have_content('神奈川')
          expect(page).to have_content('男性')
          expect(page).to have_link "@examplebbbbbbbbb1", href: "https://mobile.twitter.com/@examplebbbbbbbbb1"
        end
      end
    end

    context '異常系' do
      it '名前を空欄で更新すると失敗する' do
        fill_in User.human_attribute_name(:name), with: ''
        fill_in User.human_attribute_name(:email), with: 'user2@example.com'
        click_button I18n.t('profiles.edit.update')
        expect(page).to have_content I18n.t('defaults.messages.mypage_update_failed')
      end
      it 'メールアドレスを空欄で更新すると失敗する' do
        fill_in User.human_attribute_name(:name), with: 'user2'
        fill_in User.human_attribute_name(:email), with: ''
        click_button I18n.t('profiles.edit.update')
        expect(page).to have_content I18n.t('defaults.messages.mypage_update_failed')
      end
      it '名前とメールアドレスを空欄で更新すると失敗する' do
        fill_in User.human_attribute_name(:name), with: ''
        fill_in User.human_attribute_name(:email), with: ''
        click_button I18n.t('profiles.edit.update')
        expect(page).to have_content I18n.t('defaults.messages.mypage_update_failed')
      end
    end
  end

  describe 'プロフィールのネスト' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }
    let!(:post1) { create(:post, user_id: user1.id) }
    let!(:post2) { create(:post, user_id: user2.id) }
    let!(:post3) { create(:post, user_id: user3.id) }
    let!(:follow1) { create(:relationship, follower_id: user2.id, followed_id: user1.id) }
    let!(:follow2) { create(:relationship, follower_id: user3.id, followed_id: user1.id) }
    let!(:follow3) { create(:relationship, follower_id: user1.id, followed_id: user2.id) }
    let!(:like1) { create(:like, user_id: 1) }
    before do
      likes = create_list(:like, 5, user_id: user1.id)
      login(user1)
      visit profile_path
    end
    describe 'フォロー一覧' do
      it 'プロフィールでフォロー数が表示される' do
        following_users_number = user1.following_users.count
        expect("#js-follow-button-#{user1.id}").to have_content(following_users_number)
      end
      it 'フォローを押すとフォロー一覧へ移動' do
        click_on I18n.t('defaults.following_number')
        expect(current_path).to eq follows_profile_path
      end
    end

    describe 'フォロワー一覧' do
      it 'フォロワーを押すとフォロワー一覧へ移動' do
        click_on "フォロワー"
        expect(current_path).to eq followers_profile_path
      end
    end

    describe 'いいねした投稿一覧' do
      it 'プロフィールでいいねした投稿一覧の一部が表示' do
        expect(page).to have_content(user1.like_posts.last.memory)
      end
      it 'プロフィールからいいねした投稿一覧へ移動できる' do
        expect(page).to have_link(I18n.t('profiles.show.like_posts'))
        click_link I18n.t('profiles.show.like_posts')
        expect(page).to have_content(user1.like_posts.first.memory)
      end
    end
  end
end
