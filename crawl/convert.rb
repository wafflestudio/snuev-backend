require 'roo'
require 'roo-xls'
require 'json'
require 'csv'

if ARGV.length != 1 then
  puts "[!] Usage:"
  puts "[!] $ ruby convert.rb /path/lectures.xls"
  exit!
end

xls_path = ARGV[0]
csv_path = xls_path.gsub(".xls", ".csv")

puts "[*] Converting xls to csv"
puts "[*] - #{xls_path}"

excel = Roo::Excel.new(xls_path);
mtx = excel.to_matrix

def convert_classtime(time)
  if time.include?(",") then
    #수(7,8,9) -> 수(7-3)
    tmp = time.split(",")
    return "#{tmp[0]}-#{tmp.length})"
  elsif time.include?("-")
    return time
  else
    #수(1) -> 수(1-1)
    return time.split(")").join("")+"-1)"
  end
end

header = [
        "classification", "college", "department", "academic_year", "course_number",
        "lecture_number", "course_title", "total_credit", "lecture_credit", "lab_credit",
        "class_time", "location", "instructor", "quota", "current_quota", "enrollment",
        "remark", "language", "status"
      ]
CSV.open(csv_path, "w") do |csv|
  csv << header

  3.upto(mtx.row_size-1) do |i|
    classification = mtx[i,0]
    college = mtx[i,1]
    department = mtx[i,2]
    academic_year = mtx[i,3]
    academic_year = mtx[i,4] if academic_year == "학사"
    course_number = mtx[i,5]
    lecture_number = mtx[i,6]
    course_title = mtx[i,7]
    course_title = course_title + "(#{mtx[i,7]})" if mtx[i,8].to_s.length > 1
    total_credit = mtx[i,9].to_i
    lecture_credit = mtx[i,10].to_i
    lab_credit = mtx[i,11].to_i
    class_time = mtx[i,12]
    location = mtx[i,14]
    instructor = mtx[i,15]
    quota = mtx[i,16].to_i
    current_quota = mtx[i,16].split("(").last.to_i
    enrollment = mtx[i,17].to_i
    remark = mtx[i,18].to_s.gsub("\r\n", ", ")
    remark = remark.gsub('"', "'")
    language = mtx[i,19]
    status = mtx[i,20]

    #classtime 표기 통일
    #수(7,8,9) -> 수(7-3)
    class_time = class_time.split("/").map{|x| convert_classtime(x)}.join("/")

    csv << [
        classification, college, department, academic_year, course_number,
        lecture_number, course_title, total_credit, lecture_credit, lab_credit,
        class_time, location, instructor, quota, current_quota, enrollment,
        remark, language, status
      ]
  end
end

puts "[*] Completed"
puts "[*] - #{csv_path}"
