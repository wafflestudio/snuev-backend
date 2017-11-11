class CreateDepartmentsProfessors < ActiveRecord::Migration[5.1]
  def change
    create_table :departments_professors, id: false do |t|
      t.belongs_to :department, index: true
      t.belongs_to :professor, index: true
    end
  end
end
