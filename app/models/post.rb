class Post < ApplicationRecord
  belongs_to :user
  belongs_to :embed
  has_many :comments, dependent: :destroy
  
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
    ["age_group", "created_at", "embed_id", "memory", "music_name", "prefecture_id", "user_id"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["comments", "embed", "like_users", "likes", "prefecture", "user"]
  end
end
