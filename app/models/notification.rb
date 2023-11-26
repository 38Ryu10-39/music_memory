class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :like
  belongs_to :comment
  belongs_to :notifiable, polymorphic: true
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'

  scope :unread, -> { where(is_read: false) }
end