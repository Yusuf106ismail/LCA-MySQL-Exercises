-- ============================================================================
-- EduTrack SA - Online Compiler Sandbox Script (mycompiler.io)
-- Note: Database creation skipped to bypass online environment permissions.
-- ============================================================================

-- Task 1: Create "facilitators" Table
-- Stores instructor details. 3NF compliant with primary key and unique email.
CREATE TABLE facilitators (
    facilitator_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20)
);


-- Task 2: Create "courses" Table
-- Foreign key references facilitators table (1-to-Many).
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
-- Stores learner info with South African provinces and auto-timestamp.
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


-- Task 5: Insert Facilitator Data
INSERT INTO facilitators (first_name, last_name, email, phone) VALUES
('Sibusiso', 'Dlamini', 'sibusiso.dlamini@edutrack.co.za', '0821234567'),
('Anika', 'van der Merwe', 'anika.vdm@edutrack.co.za', '0839876543'),
('Thabo', 'Mokoena', 'thabo.mokoena@edutrack.co.za', '0715551234'),
('Farai', 'Chidimuro', 'farai.chidimuro@edutrack.co.za', '0764449876');


-- Task 6: Insert Course Data
INSERT INTO courses (course_name, duration_weeks, facilitator_id) VALUES
('Introduction to MySQL Databases', 6, 1),
('Full-Stack Web Development', 12, 2),
('Data Analytics Fundamentals', 8, 3),
('Cloud Infrastructure Essentials', 10, 4);


-- Task 7: Insert Trainee Data
INSERT INTO trainees (first_name, last_name, email, province) VALUES
('Lindiwe', 'Nkosi', 'lindiwe.nkosi@gmail.com', 'Gauteng'),
('Keanu', 'Pillay', 'keanu.pillay@yahoo.com', 'Western Cape'),
('Zandile', 'Zulu', 'zandile.zulu@hotmail.com', 'KwaZulu-Natal'),
('Bongani', 'Maseko', 'bongani.maseko@outlook.com', 'Gauteng');


-- Task 8: Insert Enrolment Data
INSERT INTO enrolments (trainee_id, course_id, enrolment_date, status) VALUES
(1, 1, '2026-01-15', 'Completed'),
(2, 2, '2026-02-01', 'Active'),
(3, 3, '2026-02-10', 'Active'),
(4, 1, '2026-01-20', 'Withdrawn'),
(1, 4, '2026-03-01', 'Active');


-- Task 9: Verification Queries
SELECT * FROM facilitators;
SELECT * FROM courses;
SELECT * FROM trainees;
SELECT * FROM enrolments;


-- Task 10: Stretch Goal Query (Gauteng Trainees)
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    province
FROM trainees
WHERE province = 'Gauteng';


-- Task 11: Join Query Verification
SELECT 
    e.enrolment_id,
    CONCAT(t.first_name, ' ', t.last_name) AS trainee_name,
    t.province,
    c.course_name,
    CONCAT(f.first_name, ' ', f.last_name) AS facilitator_name,
    e.enrolment_date,
    e.status
FROM enrolments e
JOIN trainees t ON e.trainee_id = t.trainee_id
JOIN courses c ON e.course_id = c.course_id
LEFT JOIN facilitators f ON c.facilitator_id = f.facilitator_id;
