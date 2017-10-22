FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@snu.ac.kr" }
    password "password"
  end
end
