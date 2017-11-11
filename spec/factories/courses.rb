FactoryBot.define do
  factory :course do
    association :department
    sequence(:name) { |n| "Course-#{n}" }
  end
end
