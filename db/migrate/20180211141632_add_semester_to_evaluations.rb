class AddSemesterToEvaluations < ActiveRecord::Migration[5.1]
  def change
    add_column :evaluations, :semester_id, :integer
  end
end
