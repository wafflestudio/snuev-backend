FactoryBot.define do
  factory :bookmark do
    association :user
    association :lecture
  end
end
