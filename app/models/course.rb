class Course < ApplicationRecord
  has_many :lectures
  belongs_to :department
end
