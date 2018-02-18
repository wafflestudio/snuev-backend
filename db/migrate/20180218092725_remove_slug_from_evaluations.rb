class RemoveSlugFromEvaluations < ActiveRecord::Migration[5.1]
  def change
    remove_index :evaluations, :slug
    remove_column :evaluations, :slug
  end
end
