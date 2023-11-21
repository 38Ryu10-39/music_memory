require 'rails_helper'

RSpec.describe "Comments", type: :system do
  describe 'コメント' do
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
      it 'ログインユーザーはコメント内容を入れるとコメントできる' do
        fill_in 'comment[body]', with: "コメントです"
        click_on I18n.t('posts.show.comment_submit')
        expect(page).to have_content("コメントです")
        expect(page).to have_content(I18n.t('defaults.messages.comment_create_success'))
      end
    end
    context '異常系' do
      it 'コメント内容が存在しないとコメントできない' do
        login(user1)
        visit post_path(post)
        click_on I18n.t('posts.show.comment_submit')
        expect(page).to have_content(I18n.t('defaults.messages.comment_create_failed'))
      end
      it 'ログインしていないとコメントできずログインページに戻される' do
        visit post_path(post)
        fill_in 'comment[body]', with: "コメントです"
        click_on I18n.t('posts.show.comment_submit')
        expect(current_path).to eq login_path
      end
    end
  end

  describe 'コメント' do
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
end
