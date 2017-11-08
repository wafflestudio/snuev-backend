class User < ApplicationRecord
  has_secure_password

  has_many :evaluations

  before_validation :set_email_from_username, on: :create

  validates_presence_of :username, :email, :password_digest

  private

  def set_email_from_username
    self.email ||= "#{username}@snu.ac.kr"
  end
end
