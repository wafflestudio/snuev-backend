FactoryBot.define do
  factory :semester do
    sequence(:year) { |n| 2010 + n / 4 }
    sequence(:season) { |n| n % 4 }
  end
end
