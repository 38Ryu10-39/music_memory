class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followeds, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_users, through: :followers, source: :followed
  has_many :follower_users, through: :followeds, source: :follower
  has_many :user_rooms
  has_many :chats
  has_many :rooms, through: :user_rooms

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  mount_uploader :avatar, AvatarUploader
  enum gender: {other: 0 , male: 1, female: 2}

  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end

  def mine?(object)
    object.user_id == self.id
  end

  def like_sort(post)
    if self.like?(post)
      like_posts.destroy(post)
    else
      like_posts << post
    end
  end

  def like?(post)
    like_posts.include?(post)
  end

  def follow_sort(user)
    if self.following?(user)
      followers.find_by(followed_id: user.id).destroy
    else
      followers.create(followed_id: user.id)
    end
  end
  
  def following?(user)
    following_users.include?(user)
  end
end
