class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one :notification, as: :notifiable, dependent: :destroy
  validates :message, presence: true

  after_create_commit :broadcast_and_notify

  def notification_message
    user = User.find(self.user_id)
    room = Room.find_by(id: self.room_id)
    user_link = ActionController::Base.helpers.link_to(user.name, Rails.application.routes.url_helpers.user_path(user))
    chat_link = ActionController::Base.helpers.link_to("チャット", Rails.application.routes.url_helpers.room_path(room))
    "#{user_link} さんがあなたに #{chat_link} しました".html_safe
  end

  private

  def broadcast_and_notify
    ChatBroadcastJob.perform_later(self)

    sender = self.user
    room = self.room
    receiver = room.users.where.not(id: sender.id).first

    notification = Notification.new(
      notifiable: self,
      sender: sender,
      receiver: receiver
    )

    notification.save(validate: false)
  end
end
