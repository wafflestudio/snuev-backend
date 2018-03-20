class Lecture < ApplicationRecord
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
  has_many :lecture_sessions
  has_many :bookmarks
  has_many :semesters, through: :lecture_sessions

  update_index('lectures#lecture') { self }

  def self.decorated(user = nil)
    if user
      joins("LEFT OUTER JOIN evaluations ON evaluations.lecture_id = lectures.id AND evaluations.user_id = #{user.id}")
        .joins("LEFT OUTER JOIN bookmarks ON bookmarks.lecture_id = lectures.id AND bookmarks.user_id = #{user.id}")
        .select('lectures.*, count(evaluations.*) > 0 as evaluated, count(bookmarks.*) > 0 as bookmarked')
        .group('lectures.id')
    else
      where(nil)
    end
  end

  def evaluated
    self[:evaluated] || false
  end

  def bookmarked
    self[:bookmarked] || false
  end

  def update_scores
    update(
      score: evaluations.average(:score) || 0,
      easiness: evaluations.average(:easiness) || 0,
      grading: evaluations.average(:grading) || 0
    )
  end
end
