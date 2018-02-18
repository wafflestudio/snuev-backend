class User < ApplicationRecord
  has_secure_password

  has_many :evaluations
  has_many :bookmarks

  before_validation :set_email_from_username, on: :create

  validates_presence_of :username, :email, :password_digest
  validates :password, length: { minimum: 8 }, allow_nil: true

  def confirmed?
    confirmed_at.present?
  end

  def confirm_email
    update(confirmed_at: DateTime.current, confirmation_token: nil)
  end

  def issue_reset_token
    update(
      reset_token: random_token,
      reset_sent_at: DateTime.current
    )
  end

  def issue_confirmation_token
    update(
      confirmation_token: random_token,
      confirmation_sent_at: DateTime.current
    )
  end

  private

  def set_email_from_username
    self.email ||= "#{username}@snu.ac.kr"
  end

  def random_token
    SecureRandom.urlsafe_base64.to_s
  end
end
