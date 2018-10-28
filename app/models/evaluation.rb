class Evaluation < ApplicationRecord
  belongs_to :lecture, counter_cache: true
  belongs_to :lecture_session, optional: true
  belongs_to :semester, optional: true
  belongs_to :user, optional: true
  has_many :votes, as: :votable
  has_many :upvotes, as: :votable, class_name: 'Vote::Upvote'
  has_many :downvotes, as: :votable, class_name: 'Vote::Downvote'

  validates :comment, length: { minimum: 10 }
  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true }
  validates :easiness, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true }
  validates :grading, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true }
  validates :user, uniqueness: { scope: :lecture, allow_nil: true }

  before_validation :set_default_lecture_session
  after_save :update_lecture_scores
  after_destroy :update_lecture_scores

  def self.decorated(user = nil)
    if user
      joins("LEFT OUTER JOIN votes upvotes ON upvotes.votable_id = evaluations.id AND upvotes.type = '#{Vote::Upvote}' AND upvotes.votable_type = '#{Evaluation}' AND upvotes.user_id = #{user.id}")
        .joins("LEFT OUTER JOIN votes downvotes ON downvotes.votable_id = evaluations.id AND downvotes.type = '#{Vote::Downvote}' AND downvotes.votable_type = '#{Evaluation}' AND downvotes.user_id = #{user.id}")
        .select('evaluations.*, count(upvotes.*) > 0 as upvoted, count(downvotes.*) > 0 as downvoted')
        .group('evaluations.id')
    else
      where(nil)
    end
  end

  def upvoted
    self[:upvoted] || false
  end

  def downvoted
    self[:downvoted] || false
  end

  private

  def preview
    comment.to_s[0...10]
  end

  def set_default_lecture_session
    if semester
      self.lecture_session ||= lecture.lecture_sessions.find_by(semester: semester)
    else
      self.lecture_session ||= lecture.lecture_sessions.order(semester_id: :desc).first
      self.semester = lecture_session&.semester
    end
  end

  def update_lecture_scores
    lecture.update_scores
  end
end
