class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room

  def latest_chat_message
    room.chats.order(created_at: :desc).first
  end
end
