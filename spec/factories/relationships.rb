FactoryBot.define do
  factory :relationship do
    #follower_id { 1 }
    #followed_id { 1 }
    association :follower
    association :followed
  end
end
