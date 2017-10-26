class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :evaluations

  before_validation :set_email_from_username, on: :create

  private

  def set_email_from_username
    self.email ||= "#{username}@snu.ac.kr"
  end
end
