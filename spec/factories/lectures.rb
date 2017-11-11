FactoryBot.define do
  factory :lecture do
    association :course
    association :professor
  end
end
