class Embed < ApplicationRecord
  has_many :posts, dependent: :destroy
  
  enum embed_type: { youtube: 0, apple_music: 1, spotify: 2}
end
