class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room

  def latest_chat_message
    room.chats.order(created_at: :desc).first
  end

  scope :select_my_rooms, ->(room_ids) { where(room_id: room_ids) }
  scope :excluding_user, ->(user_id) { where.not(user_id: user_id) }
  scope :latest_chat_sorted, -> { sort_by { |user_room| user_room.latest_chat_message&.created_at || Time.at(0) }.reverse }
  scope :my_user_room, ->(user_id, room_id) { where(user_id: user_id, room_id: room_id) }
end
