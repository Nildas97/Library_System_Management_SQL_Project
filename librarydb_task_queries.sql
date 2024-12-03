-- Task Queries

-- Task 1. CRUD Operations
-- Create a New Book Record 
-- "'978-1-60129-456-2', 'To Kill a Mockingbird', 
-- 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'"

SELECT * FROM books;

INSERT INTO books 
(
	"isbn",
	"book_title", 
	"category", 
	"rental_price", 
	"status", 
	"author", 
	"publisher"
)
VALUES 
(
	'978-1-60129-456-2', 
	'To Kill a Mockingbird', 
	'Classic', 
	6.00, 
	'yes', 
	'Harper Lee', 
	'J.B. Lippincott & Co.'
);

-- Task 2: Update an Existing Member's Address
SELECT * FROM members;

UPDATE members
SET member_address = '152 Cross St'
WHERE member_id = 'C101';

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' 
-- from the issued_status table.

SELECT * FROM issued_status;

DELETE FROM issued_status
WHERE issued_id = 'IS106';

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM books;
SELECT * FROM employees;
SELECT * FROM issued_status;

SELECT issued_emp_id, issued_book_name 
FROM issued_status
WHERE issued_emp_id = 'E101'
GROUP BY issued_book_name, issued_emp_id;


-- List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT * FROM members;
SELECT * FROM issued_status;

SELECT 
	issued_emp_id,
	COUNT(issued_id) AS total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_emp_id) > 3;

SELECT 
	issued_emp_id,
	issued_book_name
-- 	COUNT(issued_id) AS total_book_issued
FROM issued_status
GROUP BY issued_emp_id, issued_book_name
HAVING COUNT(issued_emp_id) > 3;

-- Task 2. CTAS (Create Table As Select)
-- Create Summary Tables: 
-- Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt

-- first create join operation
SELECT * 
FROM books as b
JOIN 
issued_status as ist
ON ist.issued_book_isbn = b.isbn

-- then check no. of books issued 
SELECT 
	b.isbn,
	b.book_title,
	COUNT(ist.issued_id) as no_issued
FROM books as b
JOIN 
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2;

-- atlast create CTAS
CREATE TABLE book_counts
AS
SELECT 
	b.isbn,
	b.book_title,
	COUNT(ist.issued_id) as no_issued
FROM books as b
JOIN 
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2;

SELECT * FROM book_counts;

-- Task 3. Data Analysis & Findings
-- Retrieve All Books in a Specific Category
SELECT * FROM books
WHERE category = 'Classic';

-- Find Total Rental Income by Category
SELECT  
	SUM(rental_price) as total_rental_price,
	category
FROM books
GROUP BY 2
HAVING SUM(rental_price) > 20;

-- Find Total Rental Income by Category
SELECT 
	b.category,
	SUM(b.rental_price) as total_book_issued,
	COUNT(*) as no_of_times_book_issued
FROM books as b
JOIN
issued_status as ist
ON 
ist.issued_book_isbn = b.isbn
GROUP BY 1;

-- List Members Who Registered in the Last 180 Days
-- adding two members for 180 records
INSERT INTO members
(
	member_id, 
	member_name, 
	member_address, 
	reg_date
)
VALUES
('C120', 'Arcane fitz', '980 Diret St', '2024-11-10'),
('C111', 'Andrew groq', '156 Main St', '2024-10-10')

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

-- List Employees with Their Branch Manager's 
-- Name and their branch details
SELECT * FROM employees;
SELECT * FROM branch;

SELECT 
	emp_name,
	branch_id
FROM employees
WHERE position = 'Manager'
GROUP BY 1,2;

-- another way

SELECT 
	e1.*,
	e2.emp_name as manager,
	b.manager_id
FROM employees as e1
JOIN
branch as b
ON b.branch_id = e1.branch_id
JOIN
employees as e2
ON
b.manager_id = e2.emp_id;

-- another way

SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id

-- Create a Table of Books with Rental 
-- Price Above a Certain Threshold

-- using CTAS
CREATE TABLE avg_rental_price
AS
SELECT 
	*
FROM books
WHERE rental_price > '6.5';
 
SELECT * FROM avg_rental_price;

-- Retrieve the List of Books Not Yet Returned
SELECT * FROM issued_status;
SELECT * FROM return_status;

SELECT *
FROM issued_status as ist
LEFT JOIN
return_status as rst
ON
ist.issued_id = rst.issued_id;
-- this will not show the not returned books
SELECT 
	DISTINCT ist.issued_book_name, ist.issued_member_id
FROM issued_status as ist
LEFT JOIN
return_status as rst
ON
ist.issued_id = rst.issued_id
WHERE rst.return_id IS NULL;
