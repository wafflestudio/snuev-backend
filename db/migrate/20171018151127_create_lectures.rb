class CreateLectures < ActiveRecord::Migration[5.1]
  def change
    create_table :lectures do |t|
      t.integer :course_id, index: true
      t.float :score, default: 0
      t.float :easiness, default: 0
      t.float :grading, default: 0

      t.timestamps
    end
  end
end
