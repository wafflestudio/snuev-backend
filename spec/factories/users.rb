FactoryBot.define do
  factory :user do
    transient do
      legacy_password nil
    end

    sequence(:username) { |n| "username#{n}" }
    password { 'password' if legacy_password.nil? }
    legacy_password_salt { SecureRandom.urlsafe_base64.to_s if legacy_password }
    legacy_password_hash { Digest::SHA1.hexdigest(legacy_password + legacy_password_salt) if legacy_password }

    trait :confirmed do
      confirmed_at { Time.now }
    end
  end
end
