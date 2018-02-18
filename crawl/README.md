# Crawl

## Introduction

`classification,college,department,academic_year,course_number,lecture_number,course_title,total_credit,lecture_credit,lab_credit,class_time,location,instructor,quota,current_quota,enrollment,remark,language,status`

`교양,인문대학,언어학과,1학년,L0441.000100,001,핀란드어 1,3,3,1,월(15:30~18:20-1)/목(17:00~17:50-1),008-408/002-110,정도상,20,10,10,수강제한 관련 수강편람 필독/주 1시간 랩수업 있음,한국어,설강`


| Raw  | Column | Value
|:-----------|:------------------------------------------|
| 교양 | lecture.category | 교양: 0, 전선: 1, 전필: 2, 교직: 3, 논문: 4
| 인문대학 | - |
| 언어학과 | department.name | string
| 1학년 | course.target_grade | integer
| L0441.000100 | course.code | string
| 001 | lecture.code | string
| 핀란드어 1 | course.name, lecture.name | string
| 3 | course.total_credit | integer
| 3 | course.lecture_credit | integer
| 1 | course.lab_credit | integer
| 월(15:30~18:20-1)/목(17:00~17:50-1) | lecture.class_time | string
| 008-408/002-110 | lecture.location | string
| 정도상 | professor.name | string
| 20 | lecture.quota | integer
| 10 | - | integer
| 10 | - | integer
| 수강제한 관련 수강편람 필독/주 1시간 랩수업 있음 | lecture.remark | string
| 한국어 | lecture.lang | string
| 설강 | lecture.status | string


## How to use

### 1. Download 수강편람 from `sugang.snu.ac.kr`

```
$ docker-compose run app rails r crawl/download.rb <year ..|2013|..> <semester 1: spring, S: summer, 2: autumn, W: winter>
```

For example,

```
$ docker-compose run app rails r crawl/download.rb 2018 1
```

the result as follows:

```
[*] Start fetching...
[*] 2018/1
[*] Downloaded:
[*] crawl/data/2018_1_2018-02-18_02:58:25.xls
```

### 2. Convert xls to csv

```
$ docker-compose run app rails r crawl/convert.rb crawl/data/2018_1_2018-02-18_02:58:25.xls
```

the result as follows:

```
[*] Converting xls to csv
[*] - crawl/data/2018_1_2018-02-18_02:58:25.xls
[*] Completed
[*] - crawl/data/2018_1_2018-02-18_02:58:25.csv
```

### 3. Insert lectures into DB

```
$ docker-compose run app rails r crawl/insert.rb crawl/data/2018_1_2018-02-18_02:58:25.csv 2018 1
```

#### Seed models

- Semester
- Department, Professor, DepartmentProfessor
- Course
- Lecture