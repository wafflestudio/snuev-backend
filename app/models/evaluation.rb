class Evaluation < ApplicationRecord
  belongs_to :lecture
  belongs_to :user

  validates :comment, length: { minimum: 10 }
  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true }
  validates :easiness, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true }
  validates :grading, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true }
  validates :user, uniqueness: { scope: :lecture }
end
