class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :user_id, uniqueness: { scope: :post_id }

  after_create_commit :create_notifications

  def notification_message
    user = User.find(user_id)
    post = Post.find(post_id)
    user_link = ActionController::Base.helpers.link_to("#{user.name} さん", Rails.application.routes.url_helpers.user_path(user))
    post_link = ActionController::Base.helpers.link_to(post.music_name, Rails.application.routes.url_helpers.post_path(post))
    "#{user_link} が #{post_link} の音楽の投稿にいいねをしました".html_safe
  end

  private

  def create_notifications
    notification = Notification.new(notifiable: self, sender: User.find(self.user_id), receiver: User.find(self.post.user_id))
    notification.save(validate: false)
  end
end
