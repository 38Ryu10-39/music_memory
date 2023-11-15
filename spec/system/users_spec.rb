require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe '新規登録' do
    context '正常系' do
      it 'Userを新規作成できる' do
        visit root_path
        expect(page).to have_content('新規登録')
        click_link '新規登録'
        fill_in '名前', with: Faker::Name.unique.name
        fill_in 'メールアドレス', with: Faker::Internet.unique.free_email
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        expect{find('input[name="commit"]').click}.to change{ User.count }.by(1)
      end
    end
    context '異常系' do
      describe '' do
        before do
          visit signup_path
        end
        let!(:user1) { create(:user) }
        it 'カラム未記入では新規登録できない' do
          find('input[name="commit"]').click
          expect(page).to have_content('新規登録')
          expect( User.count ).to eq 1
          expect(page).to have_content('もう一度お願いします')
        end
        it 'emailがすでに存在しているとき新規登録できない' do
          fill_in '名前', with: Faker::Name.unique.name
          fill_in 'メールアドレス', with: user1.email
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          find('input[name="commit"]').click
          expect( User.count ).to eq 1
          expect(page).to have_content('メールアドレスはすでに存在します')
        end
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
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        find('input[name="commit"]').click
        expect(page).to have_content(user.name)
      end
    end
    context '異常系' do
      it '新規登録ボタンを押すとログインページへ遷移' do
        find('input[name="commit"]').click
        expect(page).to have_content('ログインに失敗しました')
      end
    end
  end

  describe 'Logout' do
    let!(:user) { create(:user) }
    it 'ログアウト成功' do
      login(user)
      click_on 'ログアウト'
      expect(page).to have_content('ログアウトしました')
    end
  end
end
