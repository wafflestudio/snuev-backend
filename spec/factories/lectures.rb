FactoryGirl.define do
  factory :lecture do
    association :course
  end
end
