class User < ApplicationRecord
  has_secure_password

  has_many :evaluations

  before_validation :set_email_from_username, on: :create
  before_validation :set_confirmation_token, on: :create

  validates_presence_of :username, :email, :password_digest

  def confirmed?
    confirmed_at.present?
  end

  def confirm_email!
    update!(confirmed_at: DateTime.current, confirmation_token: nil)
  end

  private

  def set_email_from_username
    self.email ||= "#{username}@snu.ac.kr"
  end

  def set_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64.to_s
  end
end
