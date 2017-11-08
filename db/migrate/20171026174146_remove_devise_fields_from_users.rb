class RemoveDeviseFieldsFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, column: :confirmation_token, unique: true
    remove_index :users, column: :reset_password_token, unique: true
    remove_index :users, column: [:uid, :provider], unique: true

    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :remember_created_at, :datetime
    remove_column :users, :sign_in_count, :integer, default: 0, null: false
    remove_column :users, :current_sign_in_at, :datetime
    remove_column :users, :last_sign_in_at, :datetime
    remove_column :users, :current_sign_in_ip, :inet
    remove_column :users, :last_sign_in_ip, :inet
    remove_column :users, :confirmation_token, :string
    remove_column :users, :confirmed_at, :datetime
    remove_column :users, :confirmation_sent_at, :datetime
    remove_column :users, :provider, :string, null: false, default: 'email'
    remove_column :users, :uid, :string, null: false, default: ''
    remove_column :users, :tokens, :json

    rename_column :users, :encrypted_password, :password_digest
  end
end
