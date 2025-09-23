
CREATE DATABASE university_main
WITH OWNER = postgres
   TEMPLATE = template0
   ENCODING = 'LATIN9';
   LC_COLLATE = 'C'
   LC_CTYPE = 'C'

CREATE DATABASE university_archive
WITH CONNECTION LIMIT = 50
   TEMPLATE = template0;


CREATE DATABASE university_test
WITH IS_TEMPLATE = TRUE
   CONNECTION LIMIT = 10;


CREATE TABLESPACE student_data
   LOCATION '/data/students';


CREATE TABLESPACE course_data
   OWNER postgres
   LOCATION '/data/courses';


CREATE DATABASE university_distributed
   WITH TABLESPACE = student_data
   ENCODING = 'LATIN9'
   LC_COLLATE = 'C'
   LC_CTYPE = 'C';


CREATE TABLE students (
   student_id SERIAL PRIMARY KEY,
   first_name VARCHAR(50) NOT NULL,
   last_name VARCHAR(50) NOT NULL,
   email VARCHAR(100) UNIQUE,
   phone CHAR(15),
   date_of_birth DATE,
   enrollment_date DATE,
   gpa NUMERIC(3, 2),
   is_active BOOLEAN,
   graduation_year SMALLINT
);


CREATE TABLE professors (
   professor_id SERIAL PRIMARY KEY,
   first_name VARCHAR(50) NOT NULL,
   last_name VARCHAR(50) NOT NULL,
   email VARCHAR(100) UNIQUE,
   office_number VARCHAR(20),
   hire_date DATE,
   salary NUMERIC(14, 2),
   is_tenured BOOLEAN,
   years_experience INT
);


CREATE TABLE courses (
   course_id SERIAL PRIMARY KEY,
   course_code CHAR(8) NOT NULL,
   course_title VARCHAR(100) NOT NULL,
   description TEXT,
   credits SMALLINT,
   max_enrollment INT,
   course_fee NUMERIC(10, 2),
   is_online BOOLEAN,
   created_at TIMESTAMP WITHOUT TIME ZONE
);


CREATE TABLE class_schedule (
   schedule_id SERIAL PRIMARY KEY,
   course_id INT NOT NULL,
   professor_id INT NOT NULL,
   classroom VARCHAR(20),
   class_date DATE,
   start_time TIME WITHOUT TIME ZONE NOT NULL,
   end_time TIME WITHOUT TIME ZONE NOT NULL,
   duration INTERVAL
);


CREATE TABLE student_records (
   record_id SERIAL PRIMARY KEY,
   student_id INT NOT NULL,
   course_id INT NOT NULL,
   semester VARCHAR(20) NOT NULL,
   year INT NOT NULL,
   grade CHAR(2),
   attendance_percentage NUMERIC(5, 1),
   submission_timestamp TIMESTAMP WITH TIME ZONE,
   last_updated TIMESTAMP WITH TIME ZONE
);

ALTER TABLE students
   ADD COLUMN middle_name VARCHAR(30),
   ADD COLUMN student_status VARCHAR(20) DEFAULT 'ACTIVE',
   ALTER COLUMN phone TYPE VARCHAR(20),
   ALTER COLUMN gpa SET DEFAULT 0.00
;


ALTER TABLE professors
   ADD COLUMN department_code CHAR(5),
   ADD COLUMN research_area TEXT,
   ALTER COLUMN years_experience TYPE SMALLINT,
   ALTER COLUMN is_tenured SET DEFAULT FALSE,
   ADD COLUMN last_promotion_date DATE
;


ALTER TABLE courses
   ADD COLUMN prerequisite_course_id INT,
   ADD COLUMN difficulty_level SMALLINT,
   ALTER COLUMN course_code TYPE VARCHAR(10),
   ALTER COLUMN credits SET DEFAULT 3,
   ADD COLUMN lab_required BOOLEAN DEFAULT FALSE
;


ALTER TABLE class_schedule
   ADD COLUMN room_capacity INT,
   DROP COLUMN duration,
   ADD COLUMN session_type VARCHAR(15),
   ALTER COLUMN classroom TYPE VARCHAR(30),
   ADD COLUMN equipment_needed TEXT
;


ALTER TABLE student_records
   ADD COLUMN extra_credit_points NUMERIC(5, 1) DEFAULT 0.0,
   ALTER COLUMN grade TYPE VARCHAR(5),
   ADD COLUMN final_exam_date DATE,
   DROP COLUMN last_updated
;

CREATE TABLE departments (
   department_id SERIAL PRIMARY KEY,
   department_name VARCHAR(100) NOT NULL,
   department_code CHAR(5) NOT NULL,
   building VARCHAR(50),
   phone VARCHAR(15),
   budget NUMERIC(18, 2),
   established INT
);


CREATE TABLE library_books (
   book_id SERIAL PRIMARY KEY,
   isbn CHAR(13),
   title VARCHAR(200) NOT NULL,
   author VARCHAR(100) NOT NULL,
   publisher VARCHAR(100) NOT NULL,
   publication_date DATE,
   price NUMERIC(10, 2),
   is_available BOOLEAN,
   acquisition_timestamp TIMESTAMP WITHOUT TIME ZONE
);


CREATE TABLE student_book_loans (
   loan_id SERIAL PRIMARY KEY,
   student_id INT,
   book_id INT,
   loan_date DATE,
   due_date DATE,
   return_Date DATE,
   fine_amount NUMERIC(10, 2),
   loan_status VARCHAR(20)
);


ALTER TABLE professors ADD COLUMN department_id INT;

ALTER TABLE students ADD COLUMN advisor_id INT;

ALTER TABLE courses ADD COLUMN department_id INT;

CREATE TABLE grade_scale (
   grade_id SERIAL PRIMARY KEY,
   letter_grade CHAR(2),
   min_percentage NUMERIC(4, 1),
   max_percentage NUMERIC(4, 1),
   gpa_points NUMERIC(3, 2)
);

CREATE TABLE semester_calendar (
   semester_id SERIAL PRIMARY KEY,
   semester_name VARCHAR(20),
   academic_year INT,
   start_date DATE,
   end_date DATE,
   registration_deadline TIMESTAMP WITH TIME ZONE,
   is_current BOOLEAN
);


DROP TABLE IF EXISTS student_book_loans;

DROP TABLE IF EXISTS library_books;

DROP TABLE IF EXISTS grade_scale;

CREATE TABLE grade_scale (
   grade_id SERIAL PRIMARY KEY,
   letter_grade CHAR(2),
   min_percentage NUMERIC(4, 1),
   max_percentage NUMERIC(4, 1),
   gpa_points NUMERIC(3, 2),
   description TEXT
);

DROP TABLE IF EXISTS semester_calendar CASCADE;

CREATE TABLE semester_calendar (
  semester_id SERIAL PRIMARY KEY,
  semester_name VARCHAR(20),
  academic_year INT,
  start_date DATE,
  end_date DATE,
  registration_deadline TIMESTAMP WITH TIME ZONE,
  is_current BOOLEAN
);


DROP DATABASE IF EXISTS university_test;

UPDATE pg_database
   SET datistemplate = false
   WHERE datname = 'university_test'

DROP DATABASE IF EXISTS university_distributed;

SELECT pg_terminate_backend(pid)
   FROM pg_stat_activity
   WHERE datname = 'university_main'
   AND pid <> pg_backend_pid()


CREATE DATABASE university_backup
   WITH OWNER = postgres
   TEMPLATE = university_main;