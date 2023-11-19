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
        fill_in Post.human_attribute_name(:music_name), with: 'music!'
        fill_in Post.human_attribute_name(:memory), with: 'memory!'
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

  describe '動画タイプと動画のURLに関しての新規投稿後' do
    let!(:user) { create(:user) }
    before do
      login(user)
      visit new_post_path
    end
    context '動画タイプまたは動画URLのどれかにおいて空欄の場合' do
      it '動画タイプのみ空欄で動画URLが入力されている時iframeは表示されない' do
        fill_in Post.human_attribute_name(:music_name), with: 'musicnomemory'
        fill_in Post.human_attribute_name(:memory), with: 'memory!'
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        fill_in Embed.human_attribute_name(:identifer), with: 'https://www.youtube.com/watch?v=C-o8pTi6vd8&list=PLGAJbrONUQc_l3zZMKsbWqnd-af7psPqT&index=146'
        find('input[name="commit"]').click
        expect(page).to have_content('musicnomemory')
        click_on 'musicnomemory'
        expect(page).to_not have_selector 'iframe', wait: 5
      end
      it '動画URLのみ空欄で動画タイプが入力されている時iframeは表示されない' do
        fill_in Post.human_attribute_name(:music_name), with: 'musicnomemory'
        fill_in Post.human_attribute_name(:memory), with: 'memory!'
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        find("#post_embed_embed_type").find("option[value='youtube']").select_option
        find('input[name="commit"]').click
        expect(page).to have_content('musicnomemory')
        click_on 'musicnomemory'
        expect(page).to_not have_selector 'iframe', wait: 5
      end
      it '動画タイプと動画URLが両方空欄の時iframeは表示されない' do
        fill_in Post.human_attribute_name(:music_name), with: 'musicnomemory'
        fill_in Post.human_attribute_name(:memory), with: 'memory!'
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        find('input[name="commit"]').click
        expect(page).to have_content('musicnomemory')
        click_on 'musicnomemory'
        expect(page).to_not have_selector 'iframe', wait: 5
      end
    end
    context '動画タイプと動画URLが両方存在している場合' do
      it 'iframeが表示される(youtube)' do
        fill_in Post.human_attribute_name(:music_name), with: '狂乱Hey Kids!!'
        fill_in Post.human_attribute_name(:memory), with: 'memory!'
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        find("#post_embed_embed_type").find("option[value='youtube']").select_option
        fill_in Embed.human_attribute_name(:identifer), with: 'https://www.youtube.com/watch?v=C-o8pTi6vd8&list=PLGAJbrONUQc_l3zZMKsbWqnd-af7psPqT&index=146'
        find('input[name="commit"]').click
        expect(page).to have_content('狂乱Hey Kids!!')
        click_on '狂乱Hey Kids!!'
        expect(page).to have_selector 'iframe', wait: 5
      end
      it 'iframeが表示される(apple_music)' do
        fill_in Post.human_attribute_name(:music_name), with: 'さくらんぼ'
        fill_in Post.human_attribute_name(:memory), with: 'memory!'
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        find("#post_embed_embed_type").find("option[value='apple_music']").select_option
        fill_in Embed.human_attribute_name(:identifer), with: 'https://music.apple.com/jp/album/%E3%81%95%E3%81%8F%E3%82%89%E3%82%93%E3%81%BC/76106703?i=76106271'
        find('input[name="commit"]').click
        expect(page).to have_content('さくらんぼ')
        click_on 'さくらんぼ'
        expect(page).to have_selector 'iframe', wait: 5
      end
      it 'iframeが表示される(spotify)' do
        fill_in Post.human_attribute_name(:music_name), with: 'girlfriend'
        fill_in Post.human_attribute_name(:memory), with: 'musicnomemory'
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        find("#post_embed_embed_type").find("option[value='spotify']").select_option
        fill_in Embed.human_attribute_name(:identifer), with: 'https://open.spotify.com/intl-ja/artist/0p4nmQO2msCgU4IF37Wi3j'
        find('input[name="commit"]').click
        expect(page).to have_content('girlfriend')
        click_on 'girlfriend'
        expect(page).to have_selector 'iframe', wait: 5
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
      expect(page).to have_selector 'iframe', wait: 5
    end
  end
end
