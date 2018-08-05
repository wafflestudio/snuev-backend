class Course < ApplicationRecord

  has_many :lectures
  belongs_to :department

  update_index('courses#course') { self }
  update_index('lectures#lecture') { lectures }

  def tokenized_name
    splitted = name.gsub(/\(.*?\)/, ' ').squeeze(' ').gsub(/\s/, '').split('')
    (splitted[1..-1] + splitted[1..-1].combination(2).map(&:join)).map { |c| splitted[0] + c }
  end
end
