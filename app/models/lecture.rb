class Lecture < ApplicationRecord
  belongs_to :course
  has_many :evaluations
end
