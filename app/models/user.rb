class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

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
end
