class Course < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :lectures
  belongs_to :department

  update_index('courses#course') { self }
  update_index('lectures#lecture') { lectures }
end
