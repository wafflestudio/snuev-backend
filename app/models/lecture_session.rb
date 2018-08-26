class LectureSession < ApplicationRecord
  belongs_to :department, optional: true
  belongs_to :lecture
  belongs_to :semester
end
