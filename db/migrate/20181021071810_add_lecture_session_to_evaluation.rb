class AddLectureSessionToEvaluation < ActiveRecord::Migration[5.1]
  def change
    add_reference :evaluations, :lecture_session
  end
end
