FactoryBot.define do
  factory :notification do
    association :notifiable
    association :like
    association :comment
    association :notifiable
    association :sender
    association :receiver
  end
end
