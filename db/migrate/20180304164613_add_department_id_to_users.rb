class AddDepartmentIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :department_id, :integer
  end
end
