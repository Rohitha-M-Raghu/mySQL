CREATE DATABASE Day7Database;

USE Day7Database;

DROP TABLE StudentDetails ;
# Creating StudentDetails table
DROP TABLE Courses;
Drop table marks;


CREATE TABLE StudentDetails (
	student_ID 		INT NOT NULL,
    first_name 		VARCHAR(50) NOT NULL,
    last_name 		VARCHAR(50) NOT NULL,
    email_address 	VARCHAR(100) NOT NULL CHECK (Email LIKE '@gmail.com'),
    Std 			VARCHAR(10) NOT NULL,
PRIMARY KEY (student_ID)
);

SELECT * FROM StudentDetails sd ;
SELECT * FROM Marks;
SELECT *FROM Courses c ;
# Creating Marks



# Creating Courses

CREATE TABLE Courses (
    course_code 	VARCHAR(10) NOT NULL,
    course_name 	VARCHAR(50) NOT NULL,
PRIMARY KEY (course_code)
);


#Inserting Values into StudentDetails Table

insert into StudentDetails VALUES(101, 'Jamily', 'Lynn', 'jaimy.lynn@example.com');

INSERT INTO
	StudentDetails 
VALUES
	(101, 'John', 'Doe', 'john.doe@gmail.com', 'X'),
	(102, 'Jane', 'Smith', 'jane.smith@gmail.com', 'X'),
	(103, 'Mark', 'Johnson', 'mark.jonhson@gmail.com', 'XI'),
	(104, 'Sarah', 'Lee', 'sarah.lee@gmail.com', 'XII');
	;


SELECT * FROM StudentDetails ;

#Inserting Values into Marks Table


SELECT * FROM Marks;


SELECT * FROM Courses ;

ALTER TABLE Marks
CHANGE Mark Mark Decimal(3, 1);

INSERT INTO 
	Marks 
VALUES(
  	103, 
  	'ENG101', 
  	95.7, 
  	2022
);
  
SELECT DISTINCT CourseCode FROM Marks;

SELECT Count(*) from Marks;


INSERT INTO 
	Courses 
VALUES
(
	'PHY101',
	'Physics')
	
);

DROP Table Enrollment ;

CREATE TABLE Enrollment (
    StudentID INT NOT NULL,
    CourseCode VARCHAR(10) NOT NULL,
    EnrollmentYear INT NOT NULL,
    PRIMARY KEY (StudentID, CourseCode, EnrollmentYear),
    FOREIGN KEY (StudentID) REFERENCES StudentDetails(ID),
    FOREIGN KEY (CourseCode) REFERENCES Courses(Code)
);


SELECT * FROM Courses  ;
INSERT INTO 
	Enrollment  
VALUES
(
	'PHY101',
	'Physics')
	
);

select * from Courses;

SELECT * FROM StudentDetails ;

SELECT * from Marks m ;

SELECT Name, Course, 

SELECT 
	SD.FirstName, C.Name AS Subject, M.Mark, SD.Std 
FROM 
	StudentDetails SD 
JOIN 
	Marks M 
		ON 
	SD.ID = M.StudentID 
JOIN 
	Courses C 
		ON 
	M.CourseCode = C.Code 
WHERE 
	M.AcademicYear = YEAR(CURRENT_TIMESTAMP) AND M.Mark > 90
ORDER BY 
	M.Mark DESC;

DELETE FROM StudentDetails
WHERE ID = 101;

DROP TABLE Courses;
DROP TABLE Marks;
###############################################################
#Activity 1
ALTER TABLE StudentDetails
DROP PRIMARY KEY;

ALTER TABLE StudentDetails
ADD PRIMARY KEY (email_address);

-- The same implemented using MODIFY and CHANGE 
-- Change the primary key column using MODIFY
ALTER TABLE StudentDetails
MODIFY Email_Address VARCHAR(50) PRIMARY KEY;

-- Change the primary key column using CHANGE
ALTER TABLE StudentDetails
CHANGE StudentID Email_Address VARCHAR(50) PRIMARY KEY;
###############################################################
#Activity 2

CREATE TABLE Marks (
    student_ID 	  INT NOT NULL,
    course_code   VARCHAR(50) NOT NULL,
	marks 		  FLOAT NOT NULL,
    academic_year  INT NOT NULL,
PRIMARY KEY (student_ID, course_code, academic_year),
FOREIGN KEY (student_ID) REFERENCES StudentDetails(student_ID)
);

INSERT INTO
	Marks 
VALUES
	(101, 'MATH101', 92.5, 2023),
	(101, 'SCI203', 87.3, 2023),
	(102, 'MATH101', 95.2, 2023),
	(102, 'SCI203', 89.7, 2023),
	(103, 'MATH101', 91.8, 2023),
	(103, 'SCI203', 92.7, 2023),
	(101, 'MATH101', 87.6, 2022),
	(101, 'SCI203', 92.1, 2022),
	(102, 'MATH101', 91.3, 2022),
	(102, 'SCI203', 95.0, 2022),
	(103, 'MATH101', 89.5, 2022),
	(103, 'SCI203', 94.2, 2022)
;

SELECT 
	*
FROM 
	Marks;

CREATE TABLE Courses (
    course_code 	VARCHAR(10) NOT NULL,
    course_name 	VARCHAR(50) NOT NULL,
PRIMARY KEY (course_code)
);

INSERT INTO 
	Courses 
VALUES
	('MATH101', 'Mathematics'),
	('SCI203', 'Science'),
	('END315', 'English'),
	('HIS451', 'History')
;

SELECT 
	*
FROM 
	Courses;
###############################################################
#Activity 3
# List first name , subject, mark, Std of the students whose marks is greater than 90% in any Subject 
# of the current academic year. (hint check for Joins)

SELECT 
	sd.first_name, m.course_code AS subject, m.marks, sd.Std 
FROM 
	StudentDetails sd 
		JOIN
	Marks m 
		ON (sd.student_ID = m.student_ID)
WHERE 
	m.marks > 90 AND m.academic_year = YEAR(NOW());

###############################################################
#Activity 4
# Implement the same using sub-query

SELECT 
	sd.first_name, m.course_code AS subject, m.marks, sd.Std 
FROM 
	StudentDetails sd 
		JOIN
	Marks m 
		ON (sd.student_ID = m.student_ID)
WHERE m.marks IN(
	SELECT
		Marks
	FROM
		Marks 
	WHERE
		marks > 90 AND academic_year = YEAR(NOW()));

###############################################################
#Activity 5
# Delete a student entry and ensure their marks are also deleted.
ALTER TABLE Marks 
DROP FOREIGN KEY;

ALTER TABLE Marks
ADD CONSTRAINT FK_Marks_StudentID
FOREIGN KEY (student_ID) REFERENCES StudentDetails(student_ID)
ON DELETE CASCADE;

SELECT * FROM StudentDetails;
SELECT * FROM Marks;

DELETE FROM 
	StudentDetails 
WHERE student_ID = 103;
###############################################################
#Activity 6
#Design one or more extra tables for the Student Database on your own and come up with PK FK and other relationships

CREATE TABLE Enrollment (
    enrollment_ID INT PRIMARY KEY,
    student_ID INT,
    course_code VARCHAR(10),
    enrollment_date DATE
#CONSTRAINT fk_Enrollment_Student FOREIGN KEY (student_ID) REFERENCES StudentDetails(student_ID) ON DELETE CASCADE,
#CONSTRAINT fk_Enrollment_Course FOREIGN KEY (course_code) REFERENCES CourseDetails(course_code) ON DELETE CASCADE
);

###############################################################
#Activity 7
#Find students for whom no marks have been entered.
SELECT 
	sd.student_ID , sd.first_name , sd.last_name 
FROM 
	StudentDetails sd 
		JOIN
	Marks m 
		ON (sd.student_ID = m.student_ID)
WHERE
	m.marks IS NULL;

###############################################################
#Activity 8
#List first name , subject, mark, Std of the students whose marks is greater than 90% in one of the  Subjects in the current academic year and previous academic year. 

SELECT 
	sd.first_name, m.course_code AS subject, m.marks, sd.Std
FROM 
	StudentDetails sd
		JOIN 
		Marks m 
			ON sd.student_ID = m.student_ID
WHERE 
	m.academic_year IN (YEAR(NOW()), YEAR(NOW())-1) AND m.marks > 0.9 * (SELECT MAX(marks) FROM marks WHERE academic_year IN (YEAR(NOW()), YEAR(NOW())-1))
ORDER BY 
	sd.first_name;

###############################################################
#Activity 9
#Add marks of every subject of each student and then,
#- Find which student scored the highest total mark in the current academic year of std X
#- Find which student scored the lowest total mark in the current academic year of std X

SELECT 
	sd.student_ID, sd.first_name, sd.last_name, SUM(m.marks) AS total_marks
FROM 
	StudentDetails sd
		JOIN 
		Marks m ON sd.student_ID = m.student_ID
WHERE 
	m.academic_year = YEAR(CURDATE()) AND sd.Std = 'X'
GROUP BY 
	sd.student_ID
ORDER BY 
	total_marks DESC
LIMIT 1;


SELECT 
	sd.student_ID, sd.first_name, sd.last_name, SUM(m.marks) AS total_marks
FROM 
	StudentDetails sd
		JOIN 
	Marks m ON sd.student_ID = m.student_ID
WHERE 
	m.academic_year = YEAR(CURDATE()) AND sd.Std = 'X'
GROUP BY 
	sd.student_ID
ORDER BY 
	total_marks ASC
LIMIT 1;


SELECT * FROM Marks m ;
SELECT * FROM StudentDetails sd ;



