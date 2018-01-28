class AddSlugToEvaluations < ActiveRecord::Migration[5.1]
  def change
    add_column :evaluations, :slug, :string, unique: true
    add_index :evaluations, :slug, unique: true
  end
end
