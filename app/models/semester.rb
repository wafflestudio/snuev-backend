class Semester < ApplicationRecord
  enum season: %w[spring summer fall winter]

  validates :season, uniqueness: { scope: :year }
end
