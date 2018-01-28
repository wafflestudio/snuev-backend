class Professor < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_and_belongs_to_many :departments
  has_many :lectures

  update_index('lectures#lecture') { lectures }
end
