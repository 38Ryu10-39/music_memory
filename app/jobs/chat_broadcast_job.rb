class ChatBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat, options = {})
    ActionCable.server.broadcast "room_channel", { chat: render_chat(chat, options), current_user_id: options[:current_user_id] }
  end

  private

  def render_chat(chat, options)
    ApplicationController.renderer.render(partial: 'chats/chat', locals: { chat: chat, current_user_id: options[:current_user_id] })
  end
end
