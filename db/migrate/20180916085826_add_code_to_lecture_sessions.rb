class AddCodeToLectureSessions < ActiveRecord::Migration[5.1]
  def change
    add_column :lecture_sessions, :code, :string
    remove_column :lectures, :code, :string
  end
end
