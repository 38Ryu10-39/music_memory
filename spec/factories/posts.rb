FactoryBot.define do
  factory :post do
    sequence(:music_name) { |n| "My Music Name-#{n}" }
    sequence(:memory) { |n| "My Memory-#{n}" }
    association :user
  end
end
