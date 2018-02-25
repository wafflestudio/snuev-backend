class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.string :type
      t.integer :votable_id
      t.string :votable_type
      t.integer :user_id
      t.timestamps
    end

    add_index :votes, [:votable_type, :votable_id]
    add_index :votes, [:user_id, :votable_id, :votable_type], unique: true
  end
end
