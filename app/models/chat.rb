class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one :notification, as: :notifiable, dependent: :destroy

  after_create_commit { ChatBroadcastJob.perform_later(self)}
end
