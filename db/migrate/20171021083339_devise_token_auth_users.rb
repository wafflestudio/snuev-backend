class DeviseTokenAuthUsers < ActiveRecord::Migration[5.1]
  def change
    change_table(:users) do |t|
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""

      t.string :email

      t.json :tokens
    end

    add_index :users, :email, unique: true
    add_index :users, [:uid, :provider], unique: true
  end
end
