CREATE DATABASE Practice;
USE Practice;

-- 1.Create a Table
-- Create a table called Employees with the following columns:
-- EmpID (Integer, Primary Key)
-- FirstName (VARCHAR(50))
-- LastName (VARCHAR(50))
-- HireDate (DATE)
-- Salary (DECIMAL(10,2))

CREATE TABLE Employees(
EmpID INT primary key,
Firstname VARCHAR(50),
Lastname Varchar(50),
Hiredate DATE,
Salary Decimal(10,2)
);

-- 2.Create a Table with a Foreign Key
-- Create a table called Departments with columns:
-- DeptID (Integer, Primary Key)
-- DeptName (VARCHAR(100))
-- Then alter the Employees table to add a column DeptID and create a foreign key relationship to Departments.

CREATE TABLE Departments(
DeptID INT primary key,
DeptName Varchar(50)
);

ALTER TABLE Employees
ADD Column DeptID INT,
ADD constraint FOREIGN KEY (DeptID) REFERENCES Departments(DeptID);

-- 3. Add a New Column
-- Add a new column Email (VARCHAR(100)) to the Employees table.
ALTER TABLE Employees
ADD COLUMN Email VARCHAR(100);

-- 4.Modify Column Data Type
-- Change the data type of Salary in the Employees table to FLOAT.
ALTER TABLE Employees
MODIFY Salary Float;

-- 5.Rename a Column
-- Rename the column LastName in Employees table to Surname.
ALTER TABLE Employees
RENAME COLUMN Lastname to surname;


-- 6.Drop a Column
-- Drop the Email column from the Employees table.
SET SQL_SAFE_UPDATES = 0;

ALTER TABLE Employees
DROP COLUMN Email;

-- 7.Create a Table with Constraints
-- Create a table Projects with the following columns:
-- ProjectID (Integer, Primary Key)
-- ProjectName (VARCHAR(100), Not Null)
-- StartDate (DATE)
-- EndDate (DATE, should be greater than StartDate)
-- Add a check constraint to ensure that EndDate is after StartDate.

create table Projects(
ProjectID INT primary key,
ProjectName VARCHAR(100) NOT NULL,
StartDate DATE,
EndDate DATE,
CHECK (EndDATE > StartDate)
);

-- 8.Create a Unique Constraint
-- Ensure that no two employees can have the same combination of FirstName and LastName.
ALTER TABLE Staff
ADD CONSTRAINT unique_complete UNIQUE(Firstname, surname);

-- 9.Rename a Table
-- Rename the Employees table to Staff.
RENAME TABLE Employees to Staff;

-- 10.Truncate a Table
-- Remove all data from the Projects table without deleting the table itself.
truncate table Projects;


-- NOTE: Table name Employees has been changed to staff and column name lastname to surname.

-- 11.Create a Table with Composite Primary Key
-- Create a table EmployeeProjects with columns:
-- EmpID
-- ProjectID
-- Both should be part of a composite primary key.
CREATE TABLE EmployeeProjects(
EmpID INT,
ProjectID INT
);

ALTER TABLE EmployeeProjects
ADD constraint pk_emp_pr PRIMARY KEY (EmpID, ProjectID);

-- OR

CREATE TABLE EmployeeProjects(
EmpID INT,
ProjectID INT,
PRIMARY KEY(EmpID, ProjectID)
);


-- 12.Drop a Table with Foreign Key Dependency
-- Try dropping the Departments table while it's referenced by Employees. What happens? How can you handle it?
-- two options availabe: 
-- 1. 
DROP TABLE Departments;
-- since it has a foreign key reference to staff table, it is not being dropped. In this case, we first need to drop 
-- staff table then can drop departments table. 

-- or
-- 2
SHOW CREATE TABLE staff; -- this shows the constraint name then we can follow the below

ALTER TABLE staff
DROP CONSTRAINT `staff_ibfk_1` ;

-- 13.Create an Index
-- Create an index on the LastName column of the Employees table.
CREATE INDEX idx_lastname ON staff(surname);

-- 14.Create a View (though not strictly DDL in all systems)
-- Create a view ActiveEmployees that shows employees with salaries above 50,000.
CREATE VIEW ActiveEmployees AS 
select * from staff
where salary > 50000;

-- 15.Create a Table from Another Table
-- Create a table HighEarners that contains all columns from Employees where salary > 100,000.
CREATE TABLE HighEarners
select * from staff
where salary > 100000
;

-- additional information:
-- to see constraint names on an existing table, we can use any of the below queries
describe staff;

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'staff';
