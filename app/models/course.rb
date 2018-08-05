class Course < ApplicationRecord
  ENUM_TARGET_GRADE = {
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '석사': 10,
    '박사': 11,
    '석박사통합': 12
  }.with_indifferent_access

  has_many :lectures
  belongs_to :department

  update_index('courses#course') { self }
  update_index('lectures#lecture') { lectures }

  def tokenized_name
    splitted = name.gsub(/\(.*?\)/, ' ').squeeze(' ').gsub(/\s/, '').split('')
    (splitted[1..-1] + splitted[1..-1].combination(2).map(&:join)).map { |c| splitted[0] + c }
  end
end
