-- ============================================================================
-- EduTrack SA Relational Database System (Combined Exercises 01 & 03)
-- Sandbox-Friendly Version (No CREATE DATABASE / USE statements)
-- Author: Mogamed Yusuf Ismail
-- ============================================================================


-- ============================================================================
-- SECTION 1: DATABASE SCHEMA CREATION (Exercise 01)
-- ============================================================================

-- Task 1: Create "facilitators" Table
-- Stores instructor details. 3NF compliant with primary key and unique email constraint.
CREATE TABLE facilitators (
    facilitator_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20)
);


-- Task 2: Create "courses" Table
-- Linked to facilitators via Foreign Key (1-to-Many relationship).
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    duration_weeks INT NOT NULL,
    facilitator_id INT,
    CONSTRAINT fk_courses_facilitators 
        FOREIGN KEY (facilitator_id) REFERENCES facilitators(facilitator_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);


-- Task 3: Create "trainees" Table
-- Stores learner data including province and auto-generated timestamp.
CREATE TABLE trainees (
    trainee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    province VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Task 4: Create "enrolments" Table
-- Junction table connecting trainees and courses. Includes status CHECK constraint.
CREATE TABLE enrolments (
    enrolment_id INT AUTO_INCREMENT PRIMARY KEY,
    trainee_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolment_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_enrolments_trainees 
        FOREIGN KEY (trainee_id) REFERENCES trainees(trainee_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enrolments_courses 
        FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT chk_enrolment_status 
        CHECK (status IN ('Active', 'Completed', 'Withdrawn'))
);


-- ============================================================================
-- SECTION 2: DATA POPULATION (Exercise 01)
-- ============================================================================

-- Populate "facilitators" Table
INSERT INTO facilitators (first_name, last_name, email, phone) VALUES
('Sibusiso', 'Dlamini', 'sibusiso.dlamini@edutrack.co.za', '0821234567'),
('Anika', 'van der Merwe', 'anika.vdm@edutrack.co.za', '0839876543'),
('Thabo', 'Mokoena', 'thabo.mokoena@edutrack.co.za', '0715551234'),
('Farai', 'Chidimuro', 'farai.chidimuro@edutrack.co.za', '0764449876');


-- Populate "courses" Table
INSERT INTO courses (course_name, duration_weeks, facilitator_id) VALUES
('Introduction to MySQL Databases', 6, 1),
('Full-Stack Web Development', 12, 2),
('Data Analytics Fundamentals', 8, 3),
('Cloud Infrastructure Essentials', 10, 4);


-- Populate "trainees" Table
INSERT INTO trainees (first_name, last_name, email, province) VALUES
('Lindiwe', 'Nkosi', 'lindiwe.nkosi@gmail.com', 'Gauteng'),
('Keanu', 'Pillay', 'keanu.pillay@yahoo.com', 'Western Cape'),
('Zandile', 'Zulu', 'zandile.zulu@hotmail.com', 'KwaZulu-Natal'),
('Bongani', 'Maseko', 'bongani.maseko@outlook.com', 'Gauteng');


-- Populate "enrolments" Table
INSERT INTO enrolments (trainee_id, course_id, enrolment_date, status) VALUES
(1, 1, '2026-01-15', 'Completed'),
(2, 2, '2026-02-01', 'Active'),
(3, 3, '2026-02-10', 'Active'),
(4, 1, '2026-01-20', 'Withdrawn'),
(1, 4, '2026-03-01', 'Active');


-- ============================================================================
-- SECTION 3: ADVANCED JOINS & DML OPERATIONS (Exercise 03)
-- ============================================================================

-- Task 5: INNER JOIN - Enrolment List Across 3 Tables
SELECT 
    t.trainee_id,
    CONCAT(t.first_name, ' ', t.last_name) AS trainee_name,
    c.course_name,
    e.enrolment_date,
    e.status
FROM enrolments e
INNER JOIN trainees t ON e.trainee_id = t.trainee_id
INNER JOIN courses c ON e.course_id = c.course_id;


-- Task 6: INNER JOIN - Course & Facilitator Pairing
SELECT 
    c.course_id,
    c.course_name,
    CONCAT(f.first_name, ' ', f.last_name) AS facilitator_name,
    f.email AS facilitator_email
FROM courses c
INNER JOIN facilitators f ON c.facilitator_id = f.facilitator_id;


-- Task 7: LEFT JOIN - Full Trainee List (Including Unenrolled Trainees)
SELECT 
    t.trainee_id,
    CONCAT(t.first_name, ' ', t.last_name) AS trainee_name,
    t.province,
    c.course_name,
    e.status
FROM trainees t
LEFT JOIN enrolments e ON t.trainee_id = e.trainee_id
LEFT JOIN courses c ON e.course_id = c.course_id;


-- Task 8: RIGHT JOIN - Full Course List (Including Unfilled Courses)
SELECT 
    c.course_id,
    c.course_name,
    CONCAT(t.first_name, ' ', t.last_name) AS trainee_name,
    e.status
FROM enrolments e
RIGHT JOIN courses c ON e.course_id = c.course_id
LEFT JOIN trainees t ON e.trainee_id = t.trainee_id;


-- Task 9: UPDATE Statements
UPDATE trainees 
SET province = 'Western Cape' 
WHERE trainee_id = 1;

UPDATE enrolments 
SET status = 'Completed' 
WHERE trainee_id = 2 AND course_id = 2;


-- Task 10: DELETE Statement
DELETE FROM enrolments 
WHERE status = 'Withdrawn' 
ORDER BY enrolment_date ASC 
LIMIT 1;


-- Task 11: Mini Challenge - Combined SQL Query
SELECT 
    c.course_id,
    c.course_name,
    COUNT(e.trainee_id) AS active_trainee_count
FROM courses c
INNER JOIN enrolments e ON c.course_id = e.course_id
WHERE e.status = 'Active'
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.trainee_id) >= 1
ORDER BY active_trainee_count DESC;


-- Task 12: Stretch Goal - Add New Facilitator, Course, and Enrolments
INSERT INTO facilitators (first_name, last_name, email, phone) 
VALUES ('Nkosana', 'Khumalo', 'nkosana.k@edutrack.co.za', '0841112233');

INSERT INTO courses (course_name, duration_weeks, facilitator_id) 
VALUES ('Cybersecurity Essentials', 10, LAST_INSERT_ID());

INSERT INTO enrolments (trainee_id, course_id, enrolment_date, status) 
VALUES 
(2, LAST_INSERT_ID(), '2026-08-01', 'Active'),
(3, LAST_INSERT_ID(), '2026-08-01', 'Active');


-- Task 13: Verification Selects
SELECT * FROM trainees;
SELECT * FROM enrolments;
