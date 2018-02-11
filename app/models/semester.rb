class Semester < ApplicationRecord
  enum season: %w[spring summer fall winter]
end
