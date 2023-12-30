import consumer from "channels/consumer"

const appRoom = consumer.subscriptions.create("RoomChannel", {
  connected() {
    // チャンネルに接続したときの処理
    console.log('チャンネルに接続しました。');
  },

  disconnected() {
    // チャンネルから切断したときの処理
    console.log('チャンネルを切断しました。');
  },

  received(data) {
    const messages = document.querySelector('#messages');
    messages.insertAdjacentHTML('afterbegin', data['chat']);
  },

  chat(data) {
    return this.perform('chat', {data: data});
  }
});

//document.addEventListener("DOMContentLoaded", function() {
//  const chatBtn = document.querySelector('.chat_btn');
//  const newMessage = document.querySelector('#new_message');
//  const hiddenRoomId = document.querySelector('.hidden_room_id');
//  const hiddenUserId = document.querySelector('.hidden_user_id');
//  chatBtn.addEventListener("click", function(e) {
//    appRoom.chat({ message: newMessage.value, user_id: hiddenUserId.value, room_id: hiddenRoomId.value });
//    newMessage.value = '';
//    e.preventDefault();
//  });
//});

document.addEventListener("DOMContentLoaded", function() {
  const chatBtn = document.querySelector('.chat_btn');
  const newMessage = document.querySelector('#new_message');
  const hiddenRoomId = document.querySelector('.hidden_room_id');
  const hiddenUserId = document.querySelector('.hidden_user_id');
  newMessage.addEventListener("keydown", function(e) {
    if (e.key === 'Enter' && !e.metaKey) {
      e.preventDefault();
    }
    if (e.key === 'Enter' && e.metaKey) {
      sendMessage();
    }
  });
  chatBtn.addEventListener("click", function(e) {
    sendMessage();
    e.preventDefault();
  });
  function sendMessage() {
    appRoom.chat({ message: newMessage.value, user_id: hiddenUserId.value, room_id: hiddenRoomId.value });
    newMessage.value = '';
  }
});
