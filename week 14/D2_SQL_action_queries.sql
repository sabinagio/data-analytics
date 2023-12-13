/* Today's lesson -> Action queries -> queries that structurally perform changes on the table */

/* How to create a database */
CREATE DATABASE cohort;

DROP DATABASE cohort;

/* How to create a table */
CREATE TABLE 
cohort.students(
student_id INT,
student_name VARCHAR(52),
email VARCHAR(250),
coolness INT
);


/* you can create default values */
/* force values to not be NULL */

CREATE TABLE 
cohort.students(
student_id INT PRIMARY KEY,
student_name VARCHAR(52) NOT NULL,
email VARCHAR(250),
coolness INT DEFAULT 0
);


/* delete table */
DROP TABLE cohort.students;

/* insert values into EXISTING table */
INSERT INTO cohort.students(student_id, student_name, coolness)
VALUES (1, "Jose Cerqueira",  10);

INSERT INTO cohort.students(student_id, student_name, email)
VALUES (2, "Sabina Firtala",'sabina.firtala@ironhack.com');

/* Condition for creating a table */
CREATE TABLE IF NOT EXISTS
cohort.students(
student_id INT PRIMARY KEY,
student_name VARCHAR(52) NOT NULL,
email VARCHAR(250),
coolness INT DEFAULT 0
);

/*Replacing Values*/
REPLACE cohort.students(student_id, student_name, email)
VALUES (2, "Christina Cimini",'christina@aol.com'); 

/* updating the values of existing rows */
UPDATE cohort.students
SET email = "jose.cerqueira@ironhack.com"
WHERE student_id = 1;

/*if you disable "safe mode" you can do changes referring to attributes different from the primary key*/
SET SQL_SAFE_UPDATES = 0;
UPDATE cohort.students
SET email = "jose.cerqueira222@ironhack.com"
WHERE student_name LIKE "% Cerqueira";
SET SQL_SAFE_UPDATES = 1;

/* delete rows -> where do you want to delete from (which table) -> followed by, what's the criteria for you to delete? */
DELETE FROM cohort.students
WHERE  student_id =  2;

