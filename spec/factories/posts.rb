FactoryBot.define do
  factory :post do
    sequence(:music_name) { |n| "My Music Name-#{n}" }
    sequence(:memory) { |n| "My Memory-#{n}" }
    prefecture_id { 1 }
    age_group { 0 }
    association :user
    association :embed
  end
end
