class ChatBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat)
    ActionCable.server.broadcast "room_channel", { chat: render_chat(chat) }
  end

  private

  def render_chat(chat)
    ApplicationController.renderer.render(partial: 'chats/chat', locals: { chat: chat })
  end
end
