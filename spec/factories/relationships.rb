FactoryBot.define do
  factory :relationship do
    follower_id { rand(1...10) }
    followed_id { rand(1...10) }
    association :follower
    association :followed
  end
end
