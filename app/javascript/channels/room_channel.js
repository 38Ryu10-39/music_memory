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

document.addEventListener("DOMContentLoaded", function() {
  const cb = document.querySelector('.chat_btn');
  const nm = document.querySelector('#new_message');
  const hri = document.querySelector('.hidden_room_id');
  const hui = document.querySelector('.hidden_user_id');
  cb.addEventListener("click", function(e) {
    appRoom.chat({ message: nm.value, user_id: hui.value, room_id: hri.value });
    nm.value = '';
    e.preventDefault();
  });
});