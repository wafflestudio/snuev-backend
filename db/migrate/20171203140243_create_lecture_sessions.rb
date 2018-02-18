class CreateLectureSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :lecture_sessions do |t|
      t.integer :target_grade
      t.string :schedule
      t.string :classroom
      t.integer :capacity

      t.belongs_to :lecture
      t.belongs_to :semester

      t.timestamps
    end
  end
end
