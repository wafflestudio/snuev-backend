class AddImpressionsCountToLectures < ActiveRecord::Migration[5.1]
  def change
    add_column :lectures, :impressions_count, :integer, default: 0
  end
end
