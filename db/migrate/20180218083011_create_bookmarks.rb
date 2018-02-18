class CreateBookmarks < ActiveRecord::Migration[5.1]
  def change
    create_table :bookmarks do |t|
      t.integer :user_id, index: true
      t.integer :lecture_id

      t.timestamps
    end
  end
end
