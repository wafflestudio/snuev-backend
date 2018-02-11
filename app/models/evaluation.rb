class Evaluation < ApplicationRecord
  belongs_to :lecture, counter_cache: true
  belongs_to :semester, optional: true
  belongs_to :user

  validates :comment, length: { minimum: 10 }
  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true }
  validates :easiness, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true }
  validates :grading, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true }
  validates :user, uniqueness: { scope: :lecture }

  before_validation :set_default_semester
  after_save :update_lecture_scores
  after_destroy :update_lecture_scores

  private

  def set_default_semester
    self.semester ||= lecture.semesters.order(year: :desc, season: :desc).first
  end

  def update_lecture_scores
    lecture.update_scores
  end
end
