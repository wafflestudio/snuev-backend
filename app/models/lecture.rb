class Lecture < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  ENUM_CATEGORY={
    "교양": 0,
    "전선": 1,
    "전필": 2,
    "교직": 3,
    "논문": 4,
  }

  belongs_to :course
  belongs_to :professor
  has_many :evaluations

  update_index('lectures#lecture') { self }

  def update_scores
    update(
      score: evaluations.average(:score) || 0,
      easiness: evaluations.average(:easiness) || 0,
      grading: evaluations.average(:grading) || 0
    )
  end
end
