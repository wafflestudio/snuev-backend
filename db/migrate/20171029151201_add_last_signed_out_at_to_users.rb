class AddLastSignedOutAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_signed_out_at, :datetime
  end
end
