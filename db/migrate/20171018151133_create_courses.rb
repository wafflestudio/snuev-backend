class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :name, null: false, default: ''
      t.integer :department_id
      t.integer :category
      t.integer :target_grade
      t.integer :total_unit
      t.integer :lecture_unit
      t.integer :lab_unit

      t.timestamps
    end
  end
end
