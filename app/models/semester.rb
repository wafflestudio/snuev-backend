class Semester < ApplicationRecord
  enum season: %w[spring summer autumn winter]

  validates :season, uniqueness: { scope: :year }
end
