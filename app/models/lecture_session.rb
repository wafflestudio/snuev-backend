class LectureSession < ApplicationRecord
  belongs_to :lecture
  belongs_to :semester
end
