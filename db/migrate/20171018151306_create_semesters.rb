class CreateSemesters < ActiveRecord::Migration[5.1]
  def change
    create_table :semesters do |t|
      t.integer :year
      t.integer :season

      t.timestamps
    end
  end
end
