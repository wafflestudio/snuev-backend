class Professor < ApplicationRecord
  has_and_belongs_to_many :departments
  has_many :lectures

  update_index('lectures#lecture') { lectures }
end
