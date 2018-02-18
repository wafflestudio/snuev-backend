class Lecture < ApplicationRecord
  belongs_to :course
  belongs_to :professor
  has_many :evaluations
  has_many :lecture_sessions
  has_many :bookmarks
  has_many :semesters, through: :lecture_sessions

  update_index('lectures#lecture') { self }

  def self.with_bookmark(user = nil)
    if user
      joins("LEFT OUTER JOIN bookmarks ON bookmarks.lecture_id = lectures.id AND bookmarks.user_id = #{user.id}")
        .select('lectures.*, count(bookmarks.*) > 0 as bookmarked')
        .group('lectures.id')
    else
      select('lectures.*, false as bookmarked')
    end
  end

  def update_scores
    update(
      score: evaluations.average(:score) || 0,
      easiness: evaluations.average(:easiness) || 0,
      grading: evaluations.average(:grading) || 0
    )
  end
end
