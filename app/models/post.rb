class Post < ApplicationRecord
  belongs_to :user
  belongs_to :embed
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_one :notification, as: :notifiable, dependent: :destroy
  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture

  with_options presence: true do
    validates :music_name
    validates :memory
  end

  enum age_group: { childhood: 0,
                    elementary: 5, 
                    middle: 10, 
                    high: 15, 
                    early_20s: 20, 
                    late_20s: 25,
                    early_30s: 30,
                    late_30s: 35,
                    early_40s: 40,
                    late_40s: 45,
                    early_50s: 50,
                    late_50s: 55,
                    early_60s: 60,
                    late_60s: 65,
                    early_70s: 70,
                    late_70s: 75,
                  }

  
  
  def self.ransackable_attributes(auth_object = nil)
    ["music_name", "prefecture_id", "age_group"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  def age_group_i18n
    if age_group.present?
      I18n.t("enums.post.age_group.#{age_group}")
    else
      I18n.t("enums.post.age_group.unknown")
    end
  end

  after_create_commit :create_notifications

  # followしているuserが新規投稿した時

  def notification_message
    user = User.find(user_id)
    user_link = ActionController::Base.helpers.link_to(user.name, Rails.application.routes.url_helpers.user_path(user))
    post_link = ActionController::Base.helpers.link_to(self.music_name, Rails.application.routes.url_helpers.post_path(self))
    "#{user_link} さんが曲名: #{post_link} の音楽の投稿をしました".html_safe
  end

  private

  def create_notifications
    post_user = User.find(self.user_id)
    follower_users = post_user.followers
    follower_users.each do |follower_user|
      notification = Notification.new(notifiable: self, sender: User.find(self.user_id), receiver: User.find_by(id: follower_user.followed_id))
      notification.save(validate: false)
    end
  end
end
