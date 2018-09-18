class AddCourseToLectureSessions < ActiveRecord::Migration[5.1]
  def change
    remove_column :lectures, :quota, :integer, default: 0
    remove_column :lectures, :class_time, :string
    remove_column :lectures, :location, :string
    remove_column :lectures, :remark, :string
    remove_column :lectures, :lang, :string
    remove_column :lectures, :status, :string

    add_column :lecture_sessions, :quota, :integer, default: 0
    add_column :lecture_sessions, :class_time, :string
    add_column :lecture_sessions, :location, :string
    add_column :lecture_sessions, :remark, :string
    add_column :lecture_sessions, :lang, :string
    add_column :lecture_sessions, :status, :string
    add_column :lecture_sessions, :department_id, :integer
  end
end
