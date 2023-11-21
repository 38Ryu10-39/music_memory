require 'rails_helper'

RSpec.describe "Likes", js: true, type: :system do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:post1) { create(:post, user_id: user1.id) }
  let!(:post2) { create(:post, user_id: user2.id) }
  let!(:like1) { create(:like, post_id: post1.id, user_id: user2.id)}
  let!(:like2) { create(:like, post_id: post2.id, user_id: user3.id)}
  context 'ログインしている時' do
    describe '自身の投稿に関して' do
      before do
        login(user1)
        visit post_path(post1)
      end
      it '自身の投稿ではいいね数を見ることができる' do
        expect(page).to have_content("1いいね")
        expect(post1.likes.count).to eq 1
      end
    end
    describe '他のユーザーの投稿に関して' do
      context '自身がいいねしていない時' do
        before do
          login(user1)
          visit post_path(post2)
        end
        it 'いいねを押すといいねの数が増える' do
          expect(post2.likes.count).to eq 1
          find("#js-like-buttons-#{post2.id} .fa-heart").click
          expect(page).to have_content("2いいね")
        end
      end
      context '自身がすでにいいねしている時' do
        let!(:like3) { create(:like, user_id: user1.id, post_id: post2.id) }
        before do
          login(user1)
          visit post_path(post2)
        end
        it 'いいねを押すといいねの数が減る' do
          expect(post2.likes.count).to eq 2
          find("#js-like-buttons-#{post2.id} .fa-heart").click
          expect(page).to have_content("1いいね")
        end
      end
    end
  end
  context '未ログインの時' do
    it 'いいねの数だけ表示される' do
    end
  end
end
