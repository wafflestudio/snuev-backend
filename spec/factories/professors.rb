FactoryBot.define do
  factory :professor do
    sequence(:name) { |n| "professor#{n}" }
  end
end
