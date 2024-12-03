# Library_System_Management_SQL_Project

## Project Overview

**Project Title** : Library Management System
**Level** : Intermediate
**Database** : 'librarydb'

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library](https://github.com/Nildas97/Library_System_Management_SQL_Project/blob/24e11f3aa9edaaf9e7d7648599f597242db28c51/library_sample.jpg)
## Objectives

1. Set up the Library Management System 
2. Database: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
3. CRUD Operations: Perform Create, Read, Update, and Delete operations on the data.
4. CTAS (Create Table As Select): Utilize CTAS to create new tables based on query results.
5. Advanced SQL Queries: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup


![Library_db ERD](https://github.com/Nildas97/Library_System_Management_SQL_Project/blob/8e997bc31a27f8201d49f6074e980e2d9b5616d5/librarydb_erd.png)


**Database Creation**: Created a database named library_db.
**Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql

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

```

### 2. CRUD Operations
**Create**: Inserted sample records into the 'books' table.
**Read**: Retrieved and displayed data from various tables.
**Update**: Updated records in the 'employees' table.
**Delete**: Removed records from the 'members' table as needed.

**Task 1. Create a New Book Record** 
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql

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

SELECT * FROM books;
```

**Task 2: Update an Existing Member's Address**

```sql

UPDATE members
SET member_address = '152 Cross St'
WHERE member_id = 'C101';

SELECT * FROM members;

```

**Task 3: Delete a Record from the Issued Status Table** 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql

DELETE FROM issued_status
WHERE issued_id = 'IS106';

SELECT * FROM issued_status;

```

**Task 4: Retrieve All Books Issued by a Specific Employee** 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

```sql

SELECT * FROM books;
SELECT * FROM employees;
SELECT * FROM issued_status;

SELECT issued_emp_id, issued_book_name 
FROM issued_status
WHERE issued_emp_id = 'E101'
GROUP BY issued_book_name, issued_emp_id;

```

**Task 5: List Members Who Have Issued More Than One Book** 
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql

SELECT
    issued_emp_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1

```

### 3. CTAS (Create Table As Select)
**Task 6: Create Summary Tables:** Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql

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
GROUP BY b.isbn,b.book_title;

SELECT * FROM book_counts;

```

### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

**Task 7: Retrieve All Books in a Specific Category**:

```sql

SELECT * FROM books
WHERE category = 'Classic';

```

**Task 8: Find Total Rental Income by Category**:

```sql

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

```

**Task 9: List Members Who Registered in the Last 180 Days**:

```sql

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

```

**Task 10: List Employees with Their Branch Manager's Name and their branch details**:

```sql

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
ON e2.emp_id = b.manager_id;

```

**Task 11: Create a Table of Books with Rental Price Above a Certain Threshold**:

```sql

CREATE TABLE avg_rental_price
AS
SELECT 
	*
FROM books
WHERE rental_price > '6.5';
 
SELECT * FROM avg_rental_price;

```

**Task 12: Retrieve the List of Books Not Yet Returned**:

```sql

SELECT 
	DISTINCT ist.issued_book_name, ist.issued_member_id
FROM issued_status as ist
LEFT JOIN
return_status as rst
ON
ist.issued_id = rst.issued_id
WHERE rst.return_id IS NULL;

```

## ADVANCED SQL Operations

**Task 13: Identify Members with Overdue Books**
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql

SELECT 
	ist.issued_member_id,
	mem.member_name,
	bks.book_title,
	ist.issued_date,
-- 	rst.return_date,
	CURRENT_DATE - ist.issued_date AS overdue_days
FROM issued_status AS ist
JOIN 
members AS mem
ON mem.member_id = ist.issued_member_id
JOIN
books AS bks
ON bks.isbn = ist.issued_book_isbn
LEFT JOIN
return_status AS rst
ON rst.issued_id = ist.issued_id
WHERE 
	rst.return_date IS NULL
	AND
	(CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1;

```

**Task 14: Update Book Status on Return**
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

```sql

-- this can be achieved through two ways:
-- 1. manually
-- 2. stored procedures




-- MANUALLY
-- checking the book status using isbn 
SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-451-52994-2';

-- checking the book using isbn
SELECT * FROM books
WHERE isbn = '978-0-451-52994-2';

-- updating the book using isbn
UPDATE books
SET status = 'no'
WHERE isbn = '978-0-451-52994-2';

-- checking return status of same book's using issued_id
SELECT * FROM return_status
WHERE issued_id = 'IS130';

-- inserting a dummy sample for learning purpose
INSERT INTO return_status(issued_id, return_id, return_date, book_quality)
VALUES ('RS125', 'IS130', CURRENT_DATE, 'Good');

-- after insertion checking again using issued_id
SELECT * FROM return_status
WHERE issued_id = 'RS125';

-- updating the book table again
UPDATE books
SET status = 'yes'
WHERE isbn = '978-0-451-52994-2';

```


```sql

-- using STORED PROCEDURES
CREATE OR REPLACE PROCEDURE add_return_records(
	p_return_id VARCHAR(10), 
	p_issued_id VARCHAR(10), 
	p_book_quality VArchar(15)
)
LANGUAGE plpgsql
AS $$

DECLARE
-- variables with their datatypes
	v_isbn VARCHAR(50);
	v_book_name VARCHAR(80);
	

BEGIN
-- 	inserting into return based on user's input
	INSERT INTO return_status(issued_id, return_id, return_date, book_quality)
	VALUES (p_issued_id, p_return_id, CURRENT_DATE, p_book_quality);
	
-- 	getting book_name & book_isbn
	SELECT 
		issued_book_isbn,
		issued_book_name
		INTO 
		v_isbn, 
		v_book_name
	FROM issued_status
	WHERE issued_id = p_issued_id;
	
-- 	updating the book_status
	UPDATE books
	SET status = 'yes'
	WHERE isbn = v_isbn;
	
-- 	returning an output message
	RAISE NOTICE 'Thank you for returning the book: %', v_book_name;

END;
$$

CALL add_return_records()


-- TEST THE STORED PROCEDURES add_return_records()
-- select the book for checking issued_status
SELECT * FROM issued_status;

-- check the book issued_id
SELECT * FROM issued_status
WHERE issued_id = 'IS140';

-- check the book isbn number
SELECT * FROM books
WHERE isbn = '978-0-330-25864-8';

-- check book return status
SELECT * FROM return_status
WHERE issued_id = 'IS140';

-- updating the status
UPDATE books
SET status = 'no'
WHERE isbn = '978-0-330-25864-8';

DELETE FROM return_status
WHERE return_date = '2024-12-01';

-- TESTING add_return_records()
CALL add_return_records('IS140', 'RS142', 'GOOD');

```

**Task 15: Branch Performance Report**
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql

CREATE TABLE branch_reports
AS
SELECT 
	br.branch_id,
	br.manager_id,
	COUNT(ist.issued_id) AS number_book_issued,
	COUNT(rst.return_id) AS number_of_book_return,
	SUM(bk.rental_price) AS total_revenue
FROM issued_status AS ist
JOIN
employees AS emp
ON emp.emp_id = ist.issued_emp_id
-- joining branch table with above table
JOIN
branch AS br
ON emp.branch_id = br.branch_id
-- left join with return status
LEFT JOIN 
return_status AS rst
ON rst.issued_id = ist.issued_id
JOIN
books AS bk
ON bk.isbn = ist.issued_book_isbn
GROUP BY 1,2;

SELECT * FROM branch_reports;

```

**Task 16: CTAS: Create a Table of Active Members**
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN 
(SELECT 
	DISTINCT issued_member_id
FROM issued_status
WHERE 
issued_date >= CURRENT_DATE - INTERVAL '2 month'
);

SELECT * FROM active_members;

```

**Task 17: Find Employees with the Most Book Issues Processed**
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql

SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2;

```


**Task 18: Identify Members Issuing High-Risk Books**
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.

```sql

SELECT
	mem.member_name,
	ist.issued_book_name,
	COUNT(ist.issued_id) AS no_book_issued
FROM issued_status AS ist
JOIN
return_status AS rst
ON ist.issued_id = rst.issued_id
LEFT JOIN
members AS mem
ON mem.member_id = ist.issued_member_id
WHERE rst.book_quality = 'Damaged'
GROUP BY 1,2;

```

**Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system.**

Description: Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows: The stored procedure should take the book_id as an input parameter. The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

-- using STORED PROCEDURES
CREATE OR REPLACE PROCEDURE book_issue_records(
	p_issued_id VARCHAR(10), 
	p_issued_member_id VARCHAR(30), 
	p_issued_book_isbn VARCHAR(30), 
	p_issued_emp_id VARCHAR(10)
)

LANGUAGE plpgsql
AS $$

DECLARE

-- 	all the variables
	v_status VARCHAR(10);



BEGIN

-- 	all the logics
-- 	checking if book is available
	SELECT 
		status 
		INTO
		v_status
	FROM books
	WHERE isbn = p_issued_book_isbn;


	IF v_status = 'yes' THEN

		INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
		VALUES (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);


		UPDATE books
			SET status = 'no'
		WHERE isbn = p_issued_book_isbn;
		

		RAISE NOTICE 'Book records added successfully for book isbn: %', p_issued_book_isbn;
		
	ELSE
	
		RAISE NOTICE 'Sorry to inform you, this book is unavailable with book_isbn: %', p_issued_book_isbn;

	END IF;



END;
$$


SELECT *  FROM books
WHERE isbn = '978-0-19-280551-1';

SELECT * FROM issued_status;

-- "978-0-7432-7357-1" no
-- "978-0-19-280551-1" yes

CALL book_issue_records('IS155', 'C120', '978-0-19-280551-1', 'E101');

CALL book_issue_records('IS156', 'C111', '978-0-7432-7357-1', 'E105');

SELECT MAX(issued_member_id) FROM issued_status;

```

**Task 20: Create Table As Select (CTAS) Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.**

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50. The number of books issued by each member. The resulting table should show: Member ID Number of overdue books Total fines.

```sql

SELECT * FROM issued_status;
SELECT * FROM return_status;


SELECT 
	mem.member_id,
	COUNT(ist.issued_id) AS issued_books,
	CURRENT_DATE - ist.issued_date AS overdue_days,
	COUNT(CASE WHEN CURRENT_DATE - ist.issued_date > 30 THEN ist.issued_id END) AS overdue_books_count,
	SUM(CASE 
    	WHEN CURRENT_DATE - ist.issued_date > 30 
    	THEN (CURRENT_DATE - ist.issued_date - 30) * 0.50 
    	ELSE 0 
	END) AS total_fines
	
FROM issued_status AS ist
JOIN
members AS mem
ON ist.issued_member_id = mem.member_id
LEFT JOIN
return_status AS rst
ON rst.issued_id = ist.issued_id
WHERE 
	rst.return_date IS NULL
	AND
	(CURRENT_DATE - ist.issued_date) > 30
	
GROUP BY mem.member_id, ist.issued_date
ORDER BY 1;

```

### Reports

**Database Schema**: Detailed table structures and relationships.
**Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
**Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

### HOW TO USE

**Clone the Repository**: Clone this repository to your local machine.

```sh
git clone https://github.com/Nildas97/Library_System_Management_SQL_Project.git
```

**Set Up the Database**: Execute the SQL scripts in the 'librarydb.sql' file to create and populate the database.

**Run the Queries**: Use the SQL queries in the 'librarydb_insert_queries.sql' & 'librarydb_insert_queries2.sql' file to perform the analysis.

**Explore and Modify**: Customize the queries as needed to explore different aspects of the data or answer additional questions.


**Thank you for your interest in this project!**
