--Create a Database
CREATE DATABASE studentdetails;

--Create the Tables
CREATE TABLE subject (
    s_code VARCHAR(10) PRIMARY KEY,
    s_title VARCHAR(255)
);

CREATE TABLE student (
    s_reg VARCHAR(10) PRIMARY KEY,
    s_fname VARCHAR(255),
    s_sname VARCHAR(255),
    tel_no VARCHAR(15),
    address VARCHAR(255)
);

CREATE TABLE student_subject (
    s_reg VARCHAR(10),
    s_code VARCHAR(10),
    year_reg INT,
    FOREIGN KEY (s_reg) REFERENCES student(s_reg),
    FOREIGN KEY (s_code) REFERENCES subject(s_code)
);

CREATE TABLE classschedule (
    s_code VARCHAR(10),
    classhall VARCHAR(50),
    classdate DATE,
    c_day VARCHAR(15), 
    c_time TIME,
    FOREIGN KEY (s_code) REFERENCES subject(s_code)
);

CREATE TABLE classattendence (
    s_reg VARCHAR(10),
    classdate DATE,
    s_code VARCHAR(10),
    classhall VARCHAR(50),
    attendance BIT, 
    FOREIGN KEY (s_reg) REFERENCES student(s_reg),
    FOREIGN KEY (s_code) REFERENCES subject(s_code)
);

-- Insert the details
INSERT INTO subject (s_code, s_title) VALUES
('EED001', 'Electrical Engineering'),
('DS101', 'Data Technology'),
('DS102', 'Data Science'),
('DS103', 'Professional Practice');

INSERT INTO student (s_reg, s_fname, s_sname, tel_no, address) VALUES
('S001', 'Sachintha', 'Jayaweera', '0768881443', '123 Colombo'),
('S002', 'Geeth', 'Madalagama', '0781751632', '456 Rathnapura'),
('S003', 'Hiranaya', 'Dewmini', '0751565856', '789 Badulla'),
('S004', 'Theshan', 'Wijesingha', '0768881443', '25 Galgamuwa'),
('S005', 'Ishara', 'Anjitha', '0781751632', '01 Wellawa');

INSERT INTO student_subject (s_reg, s_code, year_reg) VALUES
('S001', 'EED001', 2010), 
('S001', 'DS101', 2025),  
('S002', 'EED001', 2026),
('S003', 'DS102', 2024);

INSERT INTO classschedule (s_code, classhall, classdate, c_day, c_time) VALUES
('EED001', '01', '2026-02-01', 'Sunday', '09:00'),
('DS101', 'RB-GF-3', '2026-02-02', 'Monday', '11:00'),
('DS102', '01', '2026-02-07', 'Saturday', '14:00');

INSERT INTO classattendence (s_reg, classdate, s_code, classhall, attendance) VALUES
('S001', '2026-02-01', 'EED001', '01', 1), 
('S002', '2026-02-01', 'EED001', '01', 0), 
('S001', '2026-02-02', 'DS101', 'RB-GF-3', 1);


--01. Display all subjects in the database.
SELECT *
FROM student;

--02. Show the first 5 students ordered by surname (descending).
SELECT TOP 5 *
FROM student
ORDER BY s_sname DESC;

--03. List students living in Colombo with their registration numbers and addresses.
SELECT s_reg, address 
FROM student
WHERE address LIKE '%Colombo%';

--04. Retrieve details of students registered in 2010.
SELECT * 
FROM student_subject
WHERE year_reg = 2010;

--05. Display student names with custom column headings.
SELECT s_fname AS First_Name, s_sname AS Last_Name
FROM student;

--06. Find students registered for the subject EED001.
SELECT s_reg 
FROM student_subject
WHERE s_code = 'EED001';

--07. Show the earliest registration year (labelled Oldest_Reg_Year).
SELECT MIN(year_reg) AS Oldest_Reg_Year
FROM student_subject;

--08. List subjects that have weekend classes.
SELECT DISTINCT s_code 
FROM classschedule
WHERE c_day IN ('Saturday', 'Sunday');


--09. Find subjects with Sunday classes in hall ‘01’.
SELECT DISTINCT s_code 
FROM classschedule
WHERE c_day = 'Sunday' AND classhall = '01';

--10. Show subjects that do not have Sunday classes.
SELECT s_code 
FROM subject
WHERE s_code NOT IN (
    SELECT s_code 
    FROM classschedule
    WHERE c_day = 'Sunday'
);

--11. Display student registration numbers and the length of their first names.
SELECT s_reg, LEN(s_fname) AS Name_Length
FROM student;


--12. Count how many students are registered for each subject.
SELECT s_code, COUNT(s_reg) AS Student_Count
FROM student_subject
GROUP BY s_code;


--13. Count attendance for EED001 grouped by hall.
SELECT classhall, COUNT(*) AS Attendance_Count
FROM classattendence
WHERE s_code = 'EED001'
GROUP BY classhall;


--14. Identify students who have never attended any class.
SELECT s_reg 
FROM student
WHERE s_reg NOT IN (
    SELECT DISTINCT s_reg 
    FROM classattendence
);


--15. Find students registered for more than one subject, along with the subject count.
SELECT s_reg, COUNT(s_code) AS Subject_Count
FROM student_subject
GROUP BY s_reg
HAVING COUNT(s_code) > 1;

