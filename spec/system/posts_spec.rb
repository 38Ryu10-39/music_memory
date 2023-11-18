require 'rails_helper'

RSpec.describe "Posts", type: :system do
  describe '投稿一覧' do
    context '投稿が存在しない' do
      before do
        visit posts_path
      end
      it '画面には投稿が存在しないという文が表示される' do
        expect(page).to have_content("投稿はありません")
      end
    end
    context '投稿が存在する' do
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:post1) { create(:post, user_id: user1.id) }
      before do
        login(user2)
        visit posts_path
      end
      it '投稿曲名が表示される' do
        expect(page).to have_content(post1.music_name)
      end
      it '思い出が表示される' do
        expect(page).to have_content(post1.memory)
      end
      it '投稿者名が表示される' do
        expect(page).to have_content(post1.user.name)
      end
    end
  end

  describe '新規投稿' do
    let!(:user) { create(:user) }
    before do
      login(user)
      visit new_post_path
    end
    context '正常系' do
      it '新規投稿ページから投稿できる' do
        fill_in Post.human_attribute_name(:music_name), with: 'music!'
        fill_in Post.human_attribute_name(:memory), with: 'memory!'
        expect{find('input[name="commit"]').click}.to change{ Post.count }.by(1)
      end
      it '投稿後に投稿一覧に遷移した際投稿が反映されている' do
        fill_in '曲名', with: 'music!'
        fill_in '曲の感想や思い出', with: 'memory!'
        find('input[name="commit"]').click
        expect(page).to have_content('memory!')
      end
    end
    context '異常系' do
      it '空欄で投稿した時フラッシュメッセージが出て失敗する' do
        find('input[name="commit"]').click
        expect(page).to have_content(I18n.t('defaults.messages.post_create_failed'))
      end
    end
  end

  describe '投稿詳細' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:post_show) { create(:post, user: user2, music_name: "あああ") }
    before do
      post_list = create_list(:post, 5)
      login(user1)
      visit posts_path
    end
    it '投稿一覧からリンクを押して詳細画面に移動できる' do
      click_on post_show.music_name
      expect(page).to have_content(post_show.music_name)
      expect(page).to have_content(post_show.memory)
      expect(page).to have_content(post_show.user.name)
    end
  end
end
