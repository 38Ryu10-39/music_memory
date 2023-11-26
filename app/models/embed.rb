class Embed < ApplicationRecord
  has_many :posts, dependent: :destroy

  enum embed_type: { youtube: 0, apple_music: 1, spotify: 2}

  def embed_update_judge(embed_params)
    self.embed_type = embed_params[:embed_type]
    self.identifer = embed_params[:identifer]
    self.embed_judge
    update(embed_type: self.embed_type, identifer: self.identifer)
  end

  def embed_judge
    if self.embed_type.blank? || self.identifer.blank?
      self.embed_type = ""
      self.identifer = ""
    else
      if self.youtube?
        self.identifer = youtube_identifer
      elsif self.apple_music?
        self.identifer = apple_music_identifer
      elsif self.spotify?
        self.identifer = spotify_music_identifer
      else
        self.embed_type = ""
        self.identifer = ""
      end
    end
  end
  
  def youtube_identifer
    string_identifer = identifer.split('/').last
    if string_identifer.include?("watch?v=")
      string_identifer[8, 11]
    else
      string_identifer[0, 11]
    end
  end
  
  def apple_music_identifer
    identifer.split('/').last(2).join('/')
  end
  
  def spotify_music_identifer
    identifer.split('/').last[0, 22]
  end
end
