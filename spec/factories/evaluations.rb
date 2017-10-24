FactoryGirl.define do
  factory :evaluation do
    association :lecture
    association :user
    sequence(:comment) { |n| "evaluation comment #{n}" }
  end
end
