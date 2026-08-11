-- ============================================================================
-- EduTrack SA Relational Database System (Exercise 02 - Sandbox Ready)
-- File: week1_mysql_ex02_MogamedYusufIsmail.sql
-- Author: Mogamed Yusuf Ismail
-- ============================================================================

-- SECTION 0: SCHEMA SETUP & DATA POPULATION
CREATE TABLE IF NOT EXISTS facilitators (
    facilitator_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    duration_weeks INT NOT NULL,
    facilitator_id INT,
    FOREIGN KEY (facilitator_id) REFERENCES facilitators(facilitator_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS trainees (
    trainee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    province VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS enrolments (
    enrolment_id INT AUTO_INCREMENT PRIMARY KEY,
    trainee_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolment_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trainee_id) REFERENCES trainees(trainee_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (status IN ('Active', 'Completed', 'Withdrawn'))
);

-- Insert Sample Data
INSERT INTO facilitators (first_name, last_name, email, phone) VALUES
('Sibusiso', 'Dlamini', 'sibusiso.dlamini@edutrack.co.za', '0821234567'),
('Anika', 'van der Merwe', 'anika.vdm@edutrack.co.za', '0839876543'),
('Thabo', 'Mokoena', 'thabo.mokoena@edutrack.co.za', '0715551234'),
('Farai', 'Chidimuro', 'farai.chidimuro@edutrack.co.za', '0764449876');

INSERT INTO courses (course_name, duration_weeks, facilitator_id) VALUES
('Introduction to MySQL Databases', 6, 1),
('Full-Stack Web Development', 12, 2),
('Data Analytics Fundamentals', 8, 3),
('Cloud Infrastructure Essentials', 10, 4);

INSERT INTO trainees (first_name, last_name, email, province) VALUES
('Lindiwe', 'Nkosi', 'lindiwe.nkosi@gmail.com', 'Gauteng'),
('Keanu', 'Pillay', 'keanu.pillay@yahoo.com', 'Western Cape'),
('Zandile', 'Zulu', 'zandile.zulu@hotmail.com', 'KwaZulu-Natal'),
('Bongani', 'Maseko', 'bongani.maseko@outlook.com', 'Gauteng');

INSERT INTO enrolments (trainee_id, course_id, enrolment_date, status) VALUES
(1, 1, '2026-01-15', 'Completed'),
(2, 2, '2026-02-01', 'Active'),
(3, 3, '2026-02-10', 'Active'),
(4, 1, '2026-01-20', 'Withdrawn'),
(1, 4, '2026-03-01', 'Active');


-- ============================================================================
-- SECTION 1: SORTING & LIMITS
-- ============================================================================

-- Task 1: Sort All Trainees by Surname (Ascending)
SELECT * FROM trainees 
ORDER BY last_name ASC;

-- Task 2: Sort All Courses by Duration in Weeks (Descending)
SELECT * FROM courses 
ORDER BY duration_weeks DESC;

-- Task 3: Retrieve the 3 Most Recently Enrolled Records
SELECT * FROM enrolments 
ORDER BY enrolment_date DESC 
LIMIT 3;


-- ============================================================================
-- SECTION 2: FILTERING & WILDCARDS (LIKE)
-- ============================================================================

-- Task 4: Filter Trainees by Specific Province (Gauteng)
SELECT * FROM trainees 
WHERE province = 'Gauteng';

-- Task 5: Find Trainees Whose First Name Starts with 'L' Using LIKE
SELECT * FROM trainees 
WHERE first_name LIKE 'L%';

-- Task 6: Filter Courses with Duration Greater Than 6 Weeks
SELECT * FROM courses 
WHERE duration_weeks > 6;

-- Task 7: Filter Enrolments by Status ('Active')
SELECT * FROM enrolments 
WHERE status = 'Active';


-- ============================================================================
-- SECTION 3: AGGREGATE FUNCTIONS
-- ============================================================================

-- Task 8: Count Total Number of Trainees
SELECT COUNT(*) AS total_trainees 
FROM trainees;

-- Task 9: Calculate Average and Maximum Course Duration
SELECT 
    AVG(duration_weeks) AS average_duration,
    MAX(duration_weeks) AS max_duration
FROM courses;

-- Task 10: Count Number of Enrolments Per Course
SELECT 
    course_id, 
    COUNT(enrolment_id) AS total_enrolments
FROM enrolments 
GROUP BY course_id;


-- ============================================================================
-- SECTION 4: GROUPING & HAVING
-- ============================================================================

-- Task 11: Group Trainees Count by Province
SELECT 
    province, 
    COUNT(trainee_id) AS trainee_count
FROM trainees 
GROUP BY province;

-- Task 12: Filter Provinces Having More Than 1 Trainee
SELECT 
    province, 
    COUNT(trainee_id) AS trainee_count
FROM trainees 
GROUP BY province 
HAVING COUNT(trainee_id) > 1;


-- ============================================================================
-- SECTION 5: STRETCH GOALS (OPTIONAL)
-- ============================================================================

-- Task 13: Stretch Goal 1 - Retrieve 2nd and 3rd Most Recent Enrolments Using LIMIT and OFFSET
SELECT * FROM enrolments 
ORDER BY enrolment_date DESC 
LIMIT 2 OFFSET 1;

-- Task 14: Stretch Goal 2 - Find Trainees Whose Email Ends with '.co.za'
SELECT * FROM trainees 
WHERE email LIKE '%.co.za';

-- Task 15: Stretch Goal 3 - Facilitators Who Facilitate More Than 1 Course
SELECT 
    CONCAT(f.first_name, ' ', f.last_name) AS facilitator_name,
    COUNT(c.course_id) AS course_count
FROM facilitators f
JOIN courses c ON f.facilitator_id = c.facilitator_id
GROUP BY f.facilitator_id, facilitator_name
HAVING COUNT(c.course_id) > 1;
