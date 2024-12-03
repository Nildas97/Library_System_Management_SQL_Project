-- Library Management System Project


CREATE DATABASE librarydb;

-- Create table "Branch"
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);



------------------------------------------------------------------------------------
-- DIY METHOD
-- -- CREATE DATABASE librarydb

-- -- creating branch table
-- DROP TABLE IF EXISTS branch;
-- CREATE TABLE branch
-- (
-- 	branch_id VARCHAR(10) PRIMARY KEY,
-- 	manager_id VARCHAR(10),
-- 	branch_address VARCHAR(50),
-- 	contact_no VARCHAR(0)
-- )

-- -- updating branch column contact_no 
-- ALTER TABLE branch
-- ALTER COLUMN contact_no TYPE VARCHAR(20);

-- SELECT * FROM branch;


-- DROP TABLE IF EXISTS employees;
-- CREATE TABLE employees
-- (
-- 	emp_id VARCHAR(10) PRIMARY KEY,
-- 	emp_name VARCHAR(30),
-- 	position VARCHAR(30),
-- 	salary int,
-- 	branch_id VARCHAR(30) -- FK
-- );

-- SELECT * FROM employees;

-- DROP TABLE IF EXISTS books;
-- CREATE TABLE books
-- (
-- 	isbn VARCHAR(20) PRIMARY KEY,
-- 	book_title VARCHAR(55),
-- 	category VARCHAR(20),
-- 	rental_price FLOAT,
-- 	status VARCHAR(5),
-- 	author VARCHAR(30),
-- 	publisher VARCHAR(30)
-- );

-- SELECT * FROM books;

-- DROP TABLE IF EXISTS issued_status;
-- CREATE TABLE issued_status
-- (
-- 	issued_id VARCHAR(10) PRIMARY KEY,
-- 	issued_member_id VARCHAR(10), -- FK
-- 	issued_book_name VARCHAR(70),
-- 	issued_date DATE,
-- 	issued_book_isbn VARCHAR(30), -- FK
-- 	issued_emp_id VARCHAR(10) -- FK
-- );

-- SELECT * FROM issued_status;

-- DROP TABLE IF EXISTS return_status;
-- CREATE TABLE return_status
-- (
-- 	return_id VARCHAR(10) PRIMARY KEY,
-- 	issued_id VARCHAR(10),
-- 	return_date DATE	
-- );

-- SELECT * FROM return_status;


-- DROP TABLE IF EXISTS members;
-- CREATE TABLE members
-- (
-- 	member_id VARCHAR(10) PRIMARY KEY,
-- 	member_name VARCHAR(30),
-- 	member_address VARCHAR(70),
-- 	reg_date DATE
-- );

-- -- removed return_book_name 
-- -- removed return_book_isbn

-- ALTER TABLE return_status
-- DROP COLUMN return_book_isbn;

-- SELECT * FROM return_status;

-- -- adding foreign keys

-- ALTER TABLE issued_status
-- ADD CONSTRAINT fk_issued_member_id
-- FOREIGN KEY (issued_member_id)
-- REFERENCES members(member_id);

-- -- adding foreign keys

-- ALTER TABLE issued_status
-- ADD CONSTRAINT fk_issued_book_isbn
-- FOREIGN KEY (issued_book_isbn)
-- REFERENCES books(isbn);

-- -- adding foreign keys

-- ALTER TABLE issued_status
-- ADD CONSTRAINT fk_issued_emp_id
-- FOREIGN KEY (issued_emp_id)
-- REFERENCES employees(emp_id);

-- -- adding foreign keys

-- ALTER TABLE employees
-- ADD CONSTRAINT fk_branch_id
-- FOREIGN KEY (branch_id)
-- REFERENCES branch(branch_id);

-- -- adding foreign keys

-- ALTER TABLE return_status
-- ADD CONSTRAINT fk_issued_id
-- FOREIGN KEY (issued_id)
-- REFERENCES issued_status(issued_id);
