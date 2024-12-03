-- ADVANCED SQL PROBLEM FOR LIBRARY MANAGEMENT SYSTEM
SELECT *  FROM books;
SELECT *  FROM branch;
SELECT *  FROM employees;
SELECT *  FROM issued_status;
SELECT * FROM return_status;
SELECT *  FROM members;

/*
Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books 
(assume a 30-day return period). Display the member's_id, 
member's name, book title, issue date, and days overdue.
*/

-- ((issued_status =join= members) =join= books) =join= return_status

-- filter those which are returned
-- overdue = return_date > 30 days

SELECT *  
FROM issued_status AS ist
JOIN 
members AS mem
ON mem.member_id = ist.issued_member_id
JOIN
books AS bks
ON bks.isbn = ist.issued_book_isbn
LEFT JOIN
return_status AS rst
ON rst.issued_id = ist.issued_id;

-- after that pick those columns needed 

SELECT CURRENT_DATE

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

/*
Task 14: Update Book Status on Return
Write a query to update the status of books 
in the books table to "Yes" when they are returned 
(based on entries in the return_status table).
*/

-- this can be achieved through two ways:
-- 1. manually
-- 2. stored procedures




-- manually
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




-- using stored procedures
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
-- check whether book with isbn
-- and issued_id is returned or not?

-- select the book for checking issued_status
SELECT * FROM issued_status;

-- check the book issued_id
SELECT * FROM issued_status
WHERE issued_id = 'IS135';

-- check the book isbn number
SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

-- check book return status
SELECT * FROM return_status
WHERE issued_id = 'IS135';


-- TESTING add_return_records()
CALL add_return_records('RS138', 'IS135', 'GOOD');


-- updating the mistakes in return_status
UPDATE return_status
SET return_id = 'RS130' 
WHERE return_date = '2024-12-01';



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


/*
Task 15: Branch Performance Report
Create a query that generates a performance report 
for each branch, showing the number of books issued, 
the number of books returned, and the total revenue 
generated from book rentals.
*/

SELECT * FROM branch;
SELECT * FROM issued_status;
SELECT * FROM employees;
SELECT * FROM books;
SELECT * FROM return_status;

-- joining issued_status and employees table
-- using CTAS method
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

/*
Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create
a new table active_members containing members who 
have issued at least one book in the last 2 months.
*/

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

/*
Task 17: Find Employees with the Most Book 
Issues Processed. Write a query to find the 
top 3 employees who have processed the most 
book issues. Display the employee name, number 
of books processed, and their branch.
*/

SELECT 
	emp.branch_id,
	emp.emp_name,
	COUNT(ist.issued_id) AS no_book_issued
FROM issued_status AS ist
JOIN
employees AS emp
ON emp.emp_id = ist.issued_emp_id
GROUP BY 1,2;

SELECT * FROM issued_status;
SELECT * FROM employees;

-- another way

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

/*
Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued
books more than twice with the status "damaged" in
the books table. Display the member name, book title,
and the number of times they've issued damaged books.
*/

SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;


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

/*
Task 19: Stored Procedure Objective: 
Create a stored procedure to manage the status of books 
in a library system. 

Description: Write a stored procedure 
that updates the status of a book in the library based 
on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input 
parameter. The procedure should first check if the book 
is available (status = 'yes'). If the book is available, 
it should be issued, and the status in the books table 
should be updated to 'no'. If the book is not available 
(status = 'no'), the procedure should return an error 
message indicating that the book is currently not 
available.
*/

-- using stored procedures
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

/*
Task 20: Create Table As Select (CTAS) Objective: 
Create a CTAS (Create Table As Select) query to identify
overdue books and calculate fines.

Description: Write a CTAS query to create a new table
that lists each member and the books they have issued 
but not returned within 30 days. The table should include:
The number of overdue books. The total fines, with each 
day's fine calculated at $0.50. The number of books 
issued by each member. The resulting table should show: 
Member ID Number of overdue books Total fines
*/


SELECT * FROM members;
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

