class AddSlugToLecturesAndCoursesAndProfessors < ActiveRecord::Migration[5.1]
  def change
    add_column :lectures, :slug, :string, unique: true
    add_index :lectures, :slug, unique: true

    add_column :courses, :slug, :string, unique: true
    add_index :courses, :slug, unique: true

    add_column :professors, :slug, :string, unique: true
    add_index :professors, :slug, unique: true
  end
end
