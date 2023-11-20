require 'rails_helper'

RSpec.describe "Posts", js: true, type: :system do
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
      context '投稿主が自身の投稿を見るとき' do
        let!(:user1) { create(:user) }
        let!(:user2) { create(:user) }
        let!(:post1) { create(:post, user_id: user1.id) }
        let!(:post2) { create(:post, user_id: user2.id) }
        before do
          login(user1)
          visit posts_path
        end
        it '投稿曲名が表示される' do
          expect(page).to have_content(post2.music_name)
        end
        it '思い出が表示される' do
          expect(page).to have_content(post2.memory)
        end
        it '投稿者名が表示される' do
          expect(page).to have_content(post2.user.name)
        end
      end
    end
    describe '検索機能' do
      let!(:first_user) { create(:user, name: "first-second") }
      let!(:second_user) { create(:user, name: "sec-ird") }
      let!(:third_user) { create(:user, name: "third-ec") }
      let!(:post_fu_1) { create(:post, music_name: "aaaaa-music", user_id: first_user.id)}
      let!(:post_fu_2) { create(:post, music_name: "bbbbb-music", user_id: first_user.id)}
      let!(:post_su_2) { create(:post, music_name: "aaa-music", user_id: second_user.id)}
      let!(:post_tu_1) { create(:post, music_name: "ec-music", user_id: third_user.id)}
      before do
        posts = create_list(:post, 20)
        visit posts_path
      end
      context '曲名検索の場合' do
        it '曲名を入れて検索するとその曲が表示される' do
          fill_in "q[music_name_or_memory_or_user_name_cont]", with: 'aaaaa-music'
          click_on I18n.t('defaults.search')
          expect(page).to have_content('aaaaa-music')
        end
        it '曲名の一部を入れて検索するとその文字が含まれている全ての曲が表示される' do
          fill_in "q[music_name_or_memory_or_user_name_cont]", with: 'aaa'
          click_on I18n.t('defaults.search')
          expect(page).to have_content('aaaaa-music')
          expect(page).to have_content('aaa-music')
        end
      end
      context 'ユーザー検索の場合' do
        it 'ユーザー名を入れて検索するとそのユーザーが表示される' do
          fill_in "q[music_name_or_memory_or_user_name_cont]", with: 'first-second'
          click_on I18n.t('defaults.search')
          expect(page).to have_content('first-second')
        end
        it 'ユーザー名の一部を入れて検索するとその文字が含まれている全てのユーザーが表示される' do
          fill_in "q[music_name_or_memory_or_user_name_cont]", with: 'ec'
          click_on I18n.t('defaults.search')
          expect(page).to have_content('sec-ir')
          expect(page).to have_content('third-ec')
          expect(page).to have_content('ec-music')
        end
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
      it '全ての項目を入れて投稿できる' do
        fill_in Post.human_attribute_name(:music_name), with: 'music-desu'
        fill_in Post.human_attribute_name(:memory), with: 'memory-desu'
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        find("#post_embed_embed_type").find("option[value='youtube']").select_option
        fill_in Embed.human_attribute_name(:identifer), with: "lskfjlskdjflskdjlfkj"
        click_on I18n.t('posts.new.submit')
        expect(page).to have_content('music-desu')
        click_on 'music-desu'
        expect(page).to have_selector 'iframe', wait: 5
        expect(Post.count).to eq 1
      end
      it '曲名と思い出が入力されていれば投稿できる' do
        fill_in Post.human_attribute_name(:music_name), with: 'music-desu'
        fill_in Post.human_attribute_name(:memory), with: 'memory-desu'
        click_on I18n.t('posts.new.submit')
        expect(page).to have_content('music-desu')
        expect(Post.count).to eq 1
      end
    end

    context '異常系' do
      it '曲名が空の時データの保存に失敗する' do
        fill_in Post.human_attribute_name(:memory), with: 'memory-desu'
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        find("#post_embed_embed_type").find("option[value='youtube']").select_option
        fill_in Embed.human_attribute_name(:identifer), with: "lskfjlskdjflskdjlfkj"
        expect{click_on I18n.t('posts.new.submit')}.to change { Post.count }.by(0)
      end
      it '思い出が空の時データの保存に失敗する' do
        fill_in Post.human_attribute_name(:music_name), with: 'music-desu'
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        find("#post_embed_embed_type").find("option[value='youtube']").select_option
        fill_in Embed.human_attribute_name(:identifer), with: "lskfjlskdjflskdjlfkj"
        expect{click_on I18n.t('posts.new.submit')}.to change { Post.count }.by(0)
      end
      it '曲名と思い出が空の時もデータの保存に失敗する' do
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        find("#post_embed_embed_type").find("option[value='youtube']").select_option
        fill_in Embed.human_attribute_name(:identifer), with: "lskfjlskdjflskdjlfkj"
        expect{click_on I18n.t('posts.new.submit')}.to change { Post.count }.by(0)
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
        click_on I18n.t('posts.new.submit')
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
        click_on I18n.t('posts.new.submit')
        expect(page).to have_content('musicnomemory')
        click_on 'musicnomemory'
        expect(page).to_not have_selector 'iframe', wait: 5
      end
      it '動画タイプと動画URLが両方空欄の時iframeは表示されない' do
        fill_in Post.human_attribute_name(:music_name), with: 'musicnomemory'
        fill_in Post.human_attribute_name(:memory), with: 'memory!'
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        click_on I18n.t('posts.new.submit')
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
        click_on I18n.t('posts.new.submit')
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
        click_on I18n.t('posts.new.submit')
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
        click_on I18n.t('posts.new.submit')
        expect(page).to have_content('girlfriend')
        click_on 'girlfriend'
        expect(page).to have_selector 'iframe', wait: 5
      end
    end
  end

  describe '投稿詳細' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    before do
      post_list = create_list(:post, 5)
      login(user1)
    end
    context '全ての値が入力されている場合' do
      let!(:post_show) { create(:post, user: user2, music_name: "あああ") }
      it '全ての項目が表示される' do
        visit posts_path
        click_on post_show.music_name
        expect(page).to have_content(post_show.music_name)
        expect(page).to have_content(post_show.memory)
        expect(page).to have_content(post_show.prefecture.name)
        expect(page).to have_content(post_show.age_group_i18n)
        expect(page).to have_content(post_show.user.name)
        expect(page).to have_selector 'iframe', wait: 5
      end
    end
    context '曲名と思い出以外で入力されていないものがある場合' do
      let!(:post_show_prefecture) { create(:post, prefecture_id: "") }
      let!(:post_show_age) { create(:post, age_group: "") }
      let!(:embed_notype) { create(:embed, embed_type: "") }
      let!(:embed_noidentifer) { create(:embed, identifer: "") }
      let!(:post_show_type) { create(:post, embed_id: embed_notype.id) }
      let!(:post_show_identifer) { create(:post, embed_id: embed_noidentifer.id) }
      it '聞いた地域を入力していないので聞いた地域の項目が表示されない' do
        visit post_path(post_show_prefecture)
        expect(page).to_not have_content(Post.human_attribute_name(:prefecture_id))
      end
      it '聞いた年代を入力していないので聞いた年代の項目が表示されない' do
        visit post_path(post_show_age)
        expect(page).to_not have_content(Post.human_attribute_name(:age_group))
      end
      it '動画のタイプを入力していないので動画自体が表示されない' do
        visit post_path(post_show_type)
        expect(page).to_not have_selector 'iframe', wait: 5
      end
      it 'URLを入力していないので動画自体が表示されない' do
        visit post_path(post_show_identifer)
        expect(page).to_not have_selector 'iframe', wait: 5
      end
    end
  end

  describe '投稿編集' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:post1) { create(:post, user_id: user1.id) }
    let!(:post2) { create(:post, user_id: user2.id) }
    before { login(user1) }
    it '編集前の値は正常に表示される' do
      visit post_path(post1)
      expect(page).to have_content(post1.music_name)
      expect(page).to have_content(post1.memory)
      expect(page).to have_content(post1.prefecture.name)
      expect(page).to have_content(post1.age_group_i18n)
      expect(page).to have_content(post1.user.name)
      expect(page).to have_selector 'iframe', wait: 5
    end
    context '正常系' do
      it '全ての値を更新すると情報が更新されている' do
        visit edit_post_path(post1)
        fill_in Post.human_attribute_name(:music_name), with: 'music-desu'
        fill_in Post.human_attribute_name(:memory), with: 'memory-desu'
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        find("#post_embed_embed_type").find("option[value='youtube']").select_option
        fill_in Embed.human_attribute_name(:identifer), with: "lskfjlskdjflskdjlfkj"
        click_on I18n.t('posts.edit.submit')
        expect(page).to have_content('music-desu')
        expect(page).to have_content('memory-desu')
        expect(page).to have_content('群馬県')
        expect(page).to have_content('小学生時代')
      end
    end

    context '異常系' do
      before { visit edit_post_path(post1) }
      it '全部空欄にして編集すると失敗する' do
        fill_in Post.human_attribute_name(:music_name), with: ''
        fill_in Post.human_attribute_name(:memory), with: ''
        find("#post_age_group").find("option[value='']").select_option
        find("#post_prefecture_id").find("option[value='']").select_option
        find("#post_embed_embed_type").find("option[value='']").select_option
        fill_in Embed.human_attribute_name(:identifer), with: ""
        click_on I18n.t('posts.edit.submit')
        expect(page).to have_content I18n.t('defaults.messages.post_update_failed')
      end
      it '曲名が空の時データの保存に失敗する' do
        fill_in Post.human_attribute_name(:music_name), with: ''
        fill_in Post.human_attribute_name(:memory), with: 'memory-desu'
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        find("#post_embed_embed_type").find("option[value='youtube']").select_option
        fill_in Embed.human_attribute_name(:identifer), with: "lskfjlskdjflskdjlfkj"
        click_on I18n.t('posts.edit.submit')
        expect(page).to have_content I18n.t('defaults.messages.post_update_failed')
      end
      it '思い出が空の時データの保存に失敗する' do
        fill_in Post.human_attribute_name(:music_name), with: 'music-desu'
        fill_in Post.human_attribute_name(:memory), with: ''
        find("#post_age_group").find("option[value='elementary']").select_option
        find("#post_prefecture_id").find("option[value='10']").select_option
        find("#post_embed_embed_type").find("option[value='youtube']").select_option
        fill_in Embed.human_attribute_name(:identifer), with: "lskfjlskdjflskdjlfkj"
        click_on I18n.t('posts.edit.submit')
        expect(page).to have_content I18n.t('defaults.messages.post_update_failed')
      end
    end
  end
end
