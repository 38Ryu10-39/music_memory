FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.free_email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
