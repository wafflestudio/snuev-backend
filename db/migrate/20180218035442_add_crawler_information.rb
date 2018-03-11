class AddCrawlerInformation < ActiveRecord::Migration[5.1]
  def change
    remove_column :courses, :credit
    add_column :lectures, :code, :string
    add_column :lectures, :quota, :integer, default: 0
    add_column :lectures, :class_time, :string
    add_column :lectures, :location, :string
    add_column :lectures, :remark, :string
    add_column :lectures, :lang, :string
    add_column :lectures, :status, :string
  end
end
