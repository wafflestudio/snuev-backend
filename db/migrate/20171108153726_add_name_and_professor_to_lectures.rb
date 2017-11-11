class AddNameAndProfessorToLectures < ActiveRecord::Migration[5.1]
  def change
    add_column :lectures, :name, :string
    add_column :lectures, :professor_id, :integer
  end
end
