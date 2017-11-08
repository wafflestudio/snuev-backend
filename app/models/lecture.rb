class Lecture < ApplicationRecord
  belongs_to :course
  belongs_to :professor
  has_many :evaluations
end
