require 'csv'

module Crawler
  class Migrator
    def self.migrate(csv_path, year, season)
      raise Errno::ENOENT unless File.file? csv_path
      if !(year.to_i > 1994) then
        puts "[!] 'year' shuold be greater than 1994"
        raise ArgumentError
      elsif !["spring", "autumn", "summer", "winter"].include?(season) then
        puts "[!] 'season' should be in [spring, autumn, summer, winter]"
        raise ArgumentError
      end

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
    end
  end
end