class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one :notification, as: :notifiable, dependent: :destroy

  after_create_commit { ChatBroadcastJob.perform_later self }

  def notification_message
    user_room = UserRoom.where(room_id: self.room_id).where_not(user_id: self.user_id)
    chat_partner = User.find(user_room.user_id)
    chat_link = ActionController::Base.helpers.link_to("#{chat_partner.name} さん", Rails.application.routes.url_helpers.room_path(self.room_id))
    "#{chat_link} があなたにメッセージを送りました".html_safe
  end

  private

  def create_notifications
    user_room = UserRoom.where(room_id: self.room_id).where_not(user_id: self.user_id)
    notification = Notification.new(notifiable: self, sender: User.find(self.user_id), receiver: User.find(user_room.id))
    notification.save(validate: false)
  end
end
