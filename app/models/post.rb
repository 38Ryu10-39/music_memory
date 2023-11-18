class Post < ApplicationRecord
  belongs_to :user
  #belongs_to :embed
  
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
end
