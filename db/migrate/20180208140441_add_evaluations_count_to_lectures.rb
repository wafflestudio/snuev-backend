class AddEvaluationsCountToLectures < ActiveRecord::Migration[5.1]
  def change
    add_column :lectures, :evaluations_count, :integer, default: 0
  end
end
