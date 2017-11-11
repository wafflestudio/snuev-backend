class Course < ApplicationRecord
  has_many :lectures
  belongs_to :department

  update_index('search#course') { self }
end
