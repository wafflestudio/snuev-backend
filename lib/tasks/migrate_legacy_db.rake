# frozen_string_literal: true

task :migrate_legacy_db, [:old_db_url] => [:environment] do |task, args|
  OLD_DB_URL = args.old_db_url

  class OldEvaluation < ActiveRecord::Base
    establish_connection OLD_DB_URL
    self.table_name = :evaluations

    belongs_to :seasonal_lecture, class_name: 'OldSeasonalLecture'
  end

  class OldDepartment < ActiveRecord::Base
    establish_connection OLD_DB_URL
    self.table_name = :departments
  end

  class OldProfessor < ActiveRecord::Base
    establish_connection OLD_DB_URL
    self.table_name = :professors
  end

  class OldCourse < ActiveRecord::Base
    establish_connection OLD_DB_URL
    self.table_name = :courses
  end

  class OldLecture < ActiveRecord::Base
    establish_connection OLD_DB_URL
    self.table_name = :lectures
  end

  class OldSeasonalLecture < ActiveRecord::Base
    establish_connection OLD_DB_URL
    self.table_name = :seasonal_lectures
  end

  departments_map = {}
  OldDepartment.find_each do |old_department|
    departments_map[old_department.id] = Department.create!(old_department.attributes.slice('name')).id
  end

  professors_map = {}
  OldProfessor.find_each do |old_professor|
    department_id = departments_map[old_professor.department_id]
    professor = Professor.create!(old_professor.attributes.slice('name', 'created_at', 'updated_at'))
    professor.department_ids << departments_map[department_id] if department_id
    professors_map[old_professor.id] = professor.id
  end

  courses_map = {}
  OldCourse.find_each do |old_course|
    code = "#{old_course.dep_code}.#{old_course.course_code}"
    target_grade = case old_course.target_grade
    when 1..5
      old_course.target_grade
    when 6 # 석박사통합
      12
    when 7 # 석사
      10
    when 8 # 박사
      11
    else
      0
    end
    category = case old_course.category
    when 0..299 # "전필"
      2
    when 300..599 # "전선"
      1
    when 600..602 # "기초"
      0
    when 610..615 # "핵교"
      0
    when 620..621 # "일교"
      0
    when 630 # "일선"
      0
    when 640 # "교직"
      3
    when 650 # "기타"
      0
    else # "오류"
      0
    end
    courses_map[old_course.id] = Course.create!(old_course.attributes.slice('name', 'total_unit', 'lecture_unit', 'lab_unit', 'created_at', 'updated_at').merge(code: code, target_grade: target_grade, category: category)).id
  end

  lectures_map = {}
  OldLecture.find_each do |old_lecture|
    course_id = courses_map[old_lecture.course_id]
    professor_id = professors_map[old_lecture.professor_id]
    lectures_map[old_lecture.id] = Lecture.create!(old_lecture.attributes.slice('created_at', 'updated_at').merge(course_id: course_id, professor_id: professor_id)).id
  end

  seasonal_lectures_map = {}
  OldSeasonalLecture.find_each do |old_seasonal_lecture|
    seasonal_lectures_map[old_seasonal_lecture.id] = LectureSession.create!(
      department_id: departments_map[old_seasonal_lecture.department_id],
      lecture_id: lectures_map[old_seasonal_lecture.lecture_id],
      semester: Semester.find_or_create_by(year: old_seasonal_lecture.year, season: old_seasonal_lecture.semester - 1),
      code: old_seasonal_lectures.class_code,
      quota: old_seasonal_lecture.capacity,
      location: old_seasonal_lecture.classroom,
      created_at: old_seasonal_lecture.created_at,
      updated_at: old_seasonal_lecture.updated_at,
    ).id
  end

  evaluations_map = {}
  OldEvaluation.includes(:seasonal_lecture).find_each do |old_evaluation|
    semester = old_evaluation.seasonal_lecture && Semester.find_or_create_by(year: old_evaluation.seasonal_lecture.year, season: old_evaluation.seasonal_lecture.semester - 1)
    evaluation = Evaluation.new(
      lecture_id: lectures_map[old_evaluation.lecture_id],
      comment: old_evaluation.comment&.gsub('<br />', "\n"),
      score: old_evaluation.eval_point,
      easiness: old_evaluation.difficulty_point,
      grading: old_evaluation.gpa_point,
      semester: semester,
      created_at: old_evaluation.created_at,
      updated_at: old_evaluation.updated_at
    )
    evaluation.save(valudate: false)
    evaluations_map[old_evaluation.id] = evaluation.id
  end

  puts({
    departments_map: departments_map,
    professors_map: professors_map,
    courses_map: courses_map,
    lectures_map: lectures_map,
    seasonal_lectures_map: seasonal_lectures_map,
    evaluations_map: evaluations_map
  }.to_json)
end
