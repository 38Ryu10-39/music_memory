require 'rails_helper'

RSpec.fdescribe "Chats", type: :system do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  describe 'チャットルームに関して' do
    before do
      login(user1)
    end
    context 'ユーザー詳細ページで見るとき' do
      context 'チャットルームが存在しないとき' do
        before { visit user_path(user2) }
        it 'チャットをするボタンが表示される' do
          expect(find_button I18n.t('users.show.start_chat')).to be_truthy
        end
        it 'チャットをするボタンを押すとチャットルームが作成され、チャットルームが表示される' do
          find_button(I18n.t('users.show.start_chat')).click
          expect(page).to have_content(I18n.t('rooms.show.no_chat'))
        end
      end
      context 'チャットルームが存在するとき' do
        let!(:room1) { create(:room) }
        let!(:user_room1) { create(:user_room, user_id: user1.id, room_id: room1.id) }
        let!(:user_room2) { create(:user_room, user_id: user2.id, room_id: room1.id) }
        it 'ユーザー詳細ページにチャットルームのボタンが現れる' do
          visit user_path(user2)
          find("a .fa-rocketchat").click
          expect(current_path).to eq room_path(room1.id)
        end
      end
    end
    context 'プロフィールページで見るとき' do
      context 'チャットルームが存在しないとき' do
        it 'チャットルームが存在しないことを表示される' do
          visit profile_path
          expect(page).to have_content(I18n.t('profiles.show.no_room'))
        end
      end
      context 'チャットルームが存在するとき' do
        let!(:room1) { create(:room) }
        let!(:user_room1) { create(:user_room, user_id: user1.id, room_id: room1.id) }
        let!(:user_room2) { create(:user_room, user_id: user2.id, room_id: room1.id) }
        let!(:chat) { create(:chat, user_id: user2.id, room_id: room1.id) }
        before do
          visit profile_path
        end
        it 'チャットルーム一覧のリンクを表示する' do
          expect(find_link(I18n.t('users.show.room_index'))).to be_truthy
        end
        it 'チャットルーム一覧に移動すると相手の名前が表示される' do
          find_link(I18n.t('users.show.room_index')).click
          expect(find_link(user2.name)).to be_truthy
          expect(current_path).to eq rooms_path
        end
      end
    end
  end
  describe 'チャットルームでチャットする機能' do
    let!(:room1) { create(:room) }
    let!(:user_room1) { create(:user_room, user_id: user1.id, room_id: room1.id) }
    let!(:user_room2) { create(:user_room, user_id: user2.id, room_id: room1.id) }
    let!(:chat) { create(:chat, user_id: user2.id, room_id: room1.id) }
    before do
      login(user1)
      visit room_path(room1.id)
    end
    it 'chatでメッセージを送信するとページに表示される' do
      fill_in :message, with: 'メッセージです'
      find_button(I18n.t('rooms.show.chat_submit')).click
      expect(page).to have_content("メッセージです")
    end
    it 'chatで送られたメッセージは相手のチャットルームで表示される' do
      fill_in :message, with: 'メッセージです'
      find_button(I18n.t('rooms.show.chat_submit')).click
      expect(page).to have_content("メッセージです")
      click_link I18n.t('defaults.logout')
      login(user2)
      visit room_path(room1.id)
      expect(page).to have_content("メッセージです")
    end
  end
end
