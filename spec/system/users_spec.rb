require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe '新規登録' do
    context '正常系' do
      it 'Userを新規作成できる' do
        visit root_path
        expect(page).to have_content(I18n.t('defaults.signup'))
        click_link I18n.t('defaults.signup')
        fill_in User.human_attribute_name(:name), with: Faker::Name.unique.name
        fill_in User.human_attribute_name(:email), with: Faker::Internet.unique.email
        fill_in User.human_attribute_name(:password), with: 'password'
        fill_in User.human_attribute_name(:password_confirmation), with: 'password'
        expect{click_on I18n.t('users.new.submit')}.to change{ User.count }.by(1)
      end
    end
    context '異常系' do
      before do
        visit signup_path
      end
      let!(:user1) { create(:user) }
      it 'カラム未記入では新規登録できない' do
        expect{click_on I18n.t('users.new.submit')}.to change{User.count}.by(0)
        expect(page).to have_content(I18n.t('users.new.title'))
        expect(page).to have_content(I18n.t('defaults.messages.signup_failed'))
      end
    end
  end

  describe 'Login' do
    before do
      visit login_path
    end
    let!(:user) { create(:user) }
    context '正常系' do
      it 'ログイン成功' do
        fill_in User.human_attribute_name(:email), with: user.email
        fill_in User.human_attribute_name(:password), with: 'password'
        click_on I18n.t('user_sessions.new.submit')
        expect(page).to have_content(user.name)
      end
    end
    context '異常系' do
      it '空欄のままログインボタンを押すとログインページへフラッシュメッセージと共に戻される' do
        click_on I18n.t('user_sessions.new.submit')
        expect(page).to have_content(I18n.t('defaults.messages.login_failed'))
      end
    end
  end

  describe 'Logout' do
    let!(:user) { create(:user) }
    it 'ログアウト成功' do
      login(user)
      click_on I18n.t('defaults.logout')
      expect(page).to have_content(I18n.t('defaults.messages.logout_success'))
    end
  end

  describe 'ユーザー詳細' do
    let!(:user1) { create(:user, x_id: '@exampleaaaaaaaaaa1') }
    let!(:user2) { create(:user, x_id: '@exampleaaaaaaaaaa2') }
    before do
      login(user1)
      visit user_path(user2)
    end
    it 'それぞれの情報が表示される' do
      expect(page).to have_content(user2.name)
      expect(page).to have_link user2.x_id, href: "https://mobile.twitter.com/#{user2.x_id}"
    end
  end

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
      click_on I18n.t('profiles.edit.title')
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
          click_on I18n.t('profiles.edit.update')
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
        click_on I18n.t('profiles.edit.update')
        expect(page).to have_content I18n.t('defaults.messages.mypage_update_failed')
      end
      it 'メールアドレスを空欄で更新すると失敗する' do
        fill_in User.human_attribute_name(:name), with: 'user2'
        fill_in User.human_attribute_name(:email), with: ''
        click_on I18n.t('profiles.edit.update')
        expect(page).to have_content I18n.t('defaults.messages.mypage_update_failed')
      end
      it '名前とメールアドレスを空欄で更新すると失敗する' do
        fill_in User.human_attribute_name(:name), with: ''
        fill_in User.human_attribute_name(:email), with: ''
        click_on I18n.t('profiles.edit.update')
        expect(page).to have_content I18n.t('defaults.messages.mypage_update_failed')
      end
    end
  end
end
