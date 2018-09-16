class User < ApplicationRecord
  has_secure_password

  attr_accessor :current_password, :reset_password

  belongs_to :department, optional: true
  has_many :evaluations
  has_many :bookmarks
  has_many :bookmarked_lectures, -> { select('lectures.*, true as bookmarked').distinct }, source: :lecture, through: :bookmarks

  before_validation :set_email_from_username, on: :create

  validates_presence_of :username, :email, :password_digest
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates_confirmation_of :password, allow_blank: true
  validates_presence_of :current_password, on: :update, if: :check_current_password?
  validate :current_password_is_correct, on: :update, if: :current_password

  def confirmed?
    confirmed_at.present?
  end

  def confirm_email
    update(confirmed_at: Time.current, confirmation_token: nil)
  end

  def issue_reset_token
    update(
      reset_token: random_token,
      reset_sent_at: Time.current
    )
  end

  def issue_confirmation_token
    update(
      confirmation_token: random_token,
      confirmation_sent_at: Time.current
    )
  end

  private

  def set_email_from_username
    self.email ||= "#{username}@snu.ac.kr"
  end

  def random_token
    SecureRandom.urlsafe_base64.to_s
  end

  def current_password_is_correct
    errors.add(:current_password, :incorrect) unless User.find(id).authenticate(current_password)
  end

  def check_current_password?
    password_digest_changed? && !reset_password
  end
end
