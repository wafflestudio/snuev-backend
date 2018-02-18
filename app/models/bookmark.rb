class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :lecture

  validates :lecture, uniqueness: { scope: :user }
end
