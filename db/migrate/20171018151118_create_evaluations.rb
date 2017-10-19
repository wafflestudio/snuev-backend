class CreateEvaluations < ActiveRecord::Migration[5.1]
  def change
    create_table :evaluations do |t|
      t.integer :user_id, index: true
      t.integer :lecture_id, index: true

      t.text :comment
      t.integer :score, default: 0
      t.integer :easiness, default: 0
      t.integer :grading, default: 0

      t.timestamps
    end
  end
end
