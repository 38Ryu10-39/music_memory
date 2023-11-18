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
        expect{find('input[name="commit"]').click}.to change{ User.count }.by(1)
      end
    end
    context '異常系' do
      before do
        visit signup_path
      end
      let!(:user1) { create(:user) }
      it 'カラム未記入では新規登録できない' do
        expect{find('input[name="commit"]').click}.to change{User.count}.by(0)
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
        find('input[name="commit"]').click
        expect(page).to have_content(user.name)
      end
    end
    context '異常系' do
      it '空欄のまま新規登録ボタンを押すとログインページへフラッシュメッセージと共に戻される' do
        find('input[name="commit"]').click
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
end
