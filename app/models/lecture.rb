class Lecture < ApplicationRecord
  belongs_to :course
  belongs_to :professor
  has_many :evaluations

  def update_scores
    update(
      score: evaluations.average(:score) || 0,
      easiness: evaluations.average(:easiness) || 0,
      grading: evaluations.average(:grading) || 0
    )
  end
end
