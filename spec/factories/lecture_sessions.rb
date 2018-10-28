FactoryBot.define do
  factory :lecture_session do
    association :department
    association :lecture
    association :semester
  end
end
