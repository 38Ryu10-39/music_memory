require 'rails_helper'

RSpec.fdescribe "Comments",js: true, type: :system do
  describe 'コメントする' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:post) { create(:post, user_id: user1.id) }
    let!(:comment1) { create(:comment, post_id: post.id, user_id: user1.id)}
    let!(:comment2) { create(:comment, post_id: post.id, user_id: user2.id)}
    context '正常系' do
      it 'ログインユーザーはコメント内容を入れるとコメントできる' do
        login(user1)
        visit post_path(post)
        fill_in 'comment[body]', with: "コメントです"
        click_on I18n.t('posts.show.comment_submit')
        expect(page).to have_content("コメントです")
      end
      context 'ログインしていないとき' do
        it '未ログイン用の表示が現れる' do
          visit post_path(post)
          expect(page).to have_content(I18n.t('posts.show.not_logged_in_comment'))
        end
      end
    end
    context '異常系' do
      it 'コメント内容が存在しないとコメントできない' do
        login(user1)
        visit post_path(post)
        click_on I18n.t('posts.show.comment_submit')
        expect(page).to have_content("コメントを入力してください")
      end
    end
  end

  describe 'コメント削除' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:post) { create(:post, user_id: user1.id) }
    let!(:comment1) { create(:comment, post_id: post.id, user_id: user1.id)}
    let!(:comment2) { create(:comment, post_id: post.id, user_id: user2.id)}
    context '正常系' do
      before do
        login(user1)
        visit post_path(post)
      end
      it '自身のコメントを削除できる' do
        comment_body = comment1.body
        page.accept_confirm do
          find("#js-comment-#{comment1.id} .fa-trash-can").click
        end
        expect(page).to_not have_content(comment_body)
      end
    end
    context '異常系' do
      it '他の人のコメントは削除できない' do
        login(user1)
        visit post_path(post)
        expect(page).to_not have_selector "#js-comment-#{comment2.id} .fa-trash-can"
      end
      it 'ログインしていないとコメントの削除はできない' do
        visit post_path(post)
        expect(page).to_not have_selector "#js-comment-#{comment1.id} .fa-trash-can"
        expect(page).to_not have_selector "#js-comment-#{comment2.id} .fa-trash-can"
      end
    end
  end

  describe 'コメント編集' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:post) { create(:post, user_id: user1.id) }
    let!(:comment1) { create(:comment, post_id: post.id, user_id: user1.id)}
    let!(:comment2) { create(:comment, post_id: post.id, user_id: user2.id)}
    context 'ログインしているとき' do
      before do
        login(user1)
        visit post_path(post)
      end
      it '編集ボタンを押すとフォームが現れる' do
        find("#js-comment-#{comment1.id} .fa-pen").click
        expect(page).to have_selector "#js-edit-comment-#{comment1.id}"
      end
      describe '編集のフォームでの操作' do
        before { find("#js-comment-#{comment1.id} .fa-pen").click }
        context '正常系' do
          it '別の値に変更して更新すると中身も変更される' do
            fill_in "js-comment-update-body-#{comment1.id}", with:"あああ"
            click_button I18n.t('comments.edit.update_submit')
            visit post_path(post)
            expect(page).to have_content("あああ")
          end
          it '編集ボタンを押すとフォームが消える' do
            find("#js-comment-#{comment1.id} .fa-pen").click
            expect(page).to_not have_selector "js-comment-update-body-#{comment1.id}"
          end
        end
        context '異常系' do
          it '空欄で更新するとエラーが出る' do
            fill_in "js-comment-update-body-#{comment1.id}", with:""
            click_button I18n.t('comments.edit.update_submit')
            expect(page).to have_content(comment1.body)
            expect(page).to have_content("コメントを入力してください")
          end
        end
      end
    end
  end
end
