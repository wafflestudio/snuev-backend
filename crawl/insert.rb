require 'csv'

if ARGV.length != 3 then
  puts "[!] Usage:"
  puts "[!] $ ruby insert.rb /path/lectures.csv <year ..|2013|..> <season 1: spring, S: summer, 2: autumn, W: winter>"
  exit!
end

csv_path = ARGV[0]
year = ARGV[1]
season = ARGV[2][0]

puts "[*] Insert season lectures from csv"
puts "[*] - #{csv_path}"

s = Semester.find_or_create_by(year: year, season: season)

####
# headers
####
# "classification", "college", "department", "academic_year", "course_number",
# "lecture_number", "course_title", "total_credit", "lecture_credit", "lab_creidt",
# "class_time", "location", "instructor", "quota", "current_quota", "enrollment",
# "remark", "language", "status"
CSV.foreach(csv_path, "r").each_with_index do |row, line|
  next if line == 0
  puts "[*] #{line} lectures inserted" if line % 500  == 0

  classification = row[0]
  college = row[1]
  department = row[2] #
  target_grade = row[3].to_s[0].to_i #
  course_code = row[4] #
  lecture_code = row[5]
  course_title = row[6] #
  total_credit = row[7].to_i #
  lecture_credit = row[8].to_i #
  lab_credit = row[9].to_i #
  class_time = row[10]
  location = row[11]
  professor = row[12] #
  quota = row[13].to_i
  current_quota = row[14].to_i
  enrollment = row[15].to_i
  remark = row[16]
  lang = row[17]
  status = row[18]

  dept = Department.find_or_create_by(name: department)
  prof = Professor.find_or_create_by(name: professor)
  dept.professors << prof

  c = Course.find_or_create_by(name: course_title, department: dept, code: course_code)
  c.target_grade = target_grade
  c.total_unit = total_credit
  c.lecture_unit = lecture_credit
  c.lab_unit = lab_credit
  c.category = Lecture::ENUM_CATEGORY[classification]
  c.save

  l = Lecture.find_or_create_by(name: course_title, code: lecture_code, course: c, professor: prof)
  l.quota = quota
  l.class_time = class_time
  l.location = location
  l.remark = remark
  l.lang = lang
  l.status = status
  l.save
end
