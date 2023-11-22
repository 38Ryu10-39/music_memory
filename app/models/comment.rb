class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one :notification, as: :notifiable, dependent: :destroy
  
  validates :body, presence: true

  after_create_commit :create_notifications

  def notification_message
    user = User.find(self.user_id)
    post = Post.find(self.post_id)
    user_link = ActionController::Base.helpers.link_to("#{user.name} さん", Rails.application.routes.url_helpers.user_path(user))
    post_link = ActionController::Base.helpers.link_to(post.music_name, Rails.application.routes.url_helpers.post_path(post))
    "#{user_link} が #{post_link} の投稿にコメントをしました".html_safe
  end

  private

  def create_notifications
    if self.user_id != self.post.user_id
      notification = Notification.new(notifiable: self, sender: self.user, receiver: User.find(self.post.user_id))
      notification.save(validate: false)
    else
      return false
    end
  end
end
