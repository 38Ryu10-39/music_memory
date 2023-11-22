class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  has_one :notification, as: :notifiable, dependent: :destroy

  after_create_commit :create_notifications

  def notification_message
    follower = User.find(self.follower_id)
    follower_link = ActionController::Base.helpers.link_to("#{follower.name} さん", Rails.application.routes.url_helpers.user_path(follower.id))
    "#{follower_link} があなたをフォローをしました".html_safe
  end

  private

  def create_notifications
    notification = Notification.new(notifiable: self, sender: User.find(self.follower_id), receiver: User.find(self.followed_id))
    notification.save(validate: false)
  end
end
