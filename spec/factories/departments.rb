FactoryGirl.define do
  factory :department do
    sequence(:name) { |n| "Department-#{n}" }
  end
end
