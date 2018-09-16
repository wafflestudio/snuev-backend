class AddLegacyPasswordToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :legacy_password_salt, :string
    add_column :users, :legacy_password_hash, :string
  end
end
