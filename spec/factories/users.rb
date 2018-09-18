FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "username#{n}" }
    password 'passwords'

    trait :confirmed do
      confirmed_at { Time.now }
    end
  end
end
