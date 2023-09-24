CREATE TABLE emp (
  emp_id INT,
  emp_name VARCHAR(20),
  department_id INT,
  salary INT,
  manager_id INT,
  emp_age INT
);

INSERT INTO emp VALUES (1, 'Ankit', 100,10000, 4, 39);
INSERT INTO emp VALUES (2, 'Mohit', 100, 15000, 5, 48);
INSERT INTO emp VALUES (3, 'Vikas', 100, 10000,4,37);
INSERT INTO emp VALUES (4, 'Rohit', 100, 5000, 2, 16);
INSERT INTO emp VALUES (5, 'Mudit', 200, 12000, 6,55);
INSERT INTO emp VALUES (6, 'Agam', 200, 12000,2, 14);
INSERT INTO emp VALUES (7, 'Sanjay', 200, 9000, 2,13);
INSERT INTO emp VALUES (8, 'Ashish', 200,5000,2,12);
INSERT INTO emp VALUES (9, 'Mukesh',300,6000,6,51);
INSERT INTO emp VALUES (10, 'Rakesh',300,7000,6,50);

Select *
from emp

CREATE TABLE department(
 
 dept_id INT,
 dept_name VARCHAR(10)
 );
 
INSERT INTO department values(100,'Analytics');
INSERT INTO department values(300,'IT');

select*
from department

CREATE TABLE orders(
 customer_name CHAR(10),
 order_date DATE,
 order_amount INT,
 customer_gender CHAR(6)
 );
 
INSERT INTO orders values('Shilpa','2020-01-01',10000,'Female');
INSERT INTO orders values('Rahul','2020-01-02',12000,'Male');
INSERT INTO orders values('PRADEEP','2020-01-02',12000,'Female');
INSERT INTO orders values('Rohit','2020-01-03',15000,'Male');
INSERT INTO orders values('pradeep','2020-01-03',14000,'Female');
 
INSERT INTO department values(100,'Analytics');
INSERT INTO department values(300,'IT');

SELECT*
FROM orders

--Q1 find duplicates in table

SELECT emp_id, COUNT (*)
FROM emp
GROUP BY emp_id
HAVING COUNT (*) >1

--Q2 delete duplicates

WITH dupCTE AS (
SELECT *, ROW_NUMBER () OVER (PARTITION BY emp_id ORDER BY emp_id) AS rn
FROM emp)
DELETE FROM dupCTE WHERE rn>1

--use Row_number to create new column rn. partition by emp_id means row numbers assigned separately for each unique emp_id
--  ORDER BY emp_id clause orders the rows within each partition by emp_id.

--Q3difference between UNION and UNION ALL
-- UNION and UNION ALL operators in SQL are used to combine the result sets of two or more SELECT statements into a single result set. However, they differ in how they handle duplicate rows:
--UNION - remove duplicates
--UNION ALL - include duplicates

SELECT * FROM emp 
UNION 
SELECT * FROM emp;

--only distinct rows

SELECT * FROM emp 
UNION ALL 
SELECT * FROM emp;

-- include ALL

--Q4 Rank/ROW NUMBER/ DENSE RANK

SELECT 
       emp_id, 
       emp_name, 
       salary, 
       RANK() OVER(ORDER BY salary DESC) AS rnk 
FROM 
       emp;

-- assigns ranks based on salary in descending order using RANK(). If multiple employees have the same salary, they will receive the same rank, and the next rank will skip the number of tied employees.

SELECT 
      emp_id, 
      emp_name, 
      salary, 
      ROW_NUMBER() OVER(ORDER BY salary DESC) AS rn 
FROM 
      emp;

-- assigns row numbers based on salary in descending order using ROW_NUMBER(). It assigns a unique row number to each employee, regardless of ties in salary.

SELECT 
      emp_id, 
      emp_name, 
      salary, 
      DENSE_RANK() OVER(ORDER BY salary DESC) AS rn 
FROM 
      emp;

--assigns dense ranks based on salary in descending order using DENSE_RANK()
--If multiple employees have the same salary, they will receive the same dense rank, and the next dense rank will not skip any values.

--Q 5 — Employees who are not present in department table?

SELECT 
    *
FROM
    emp AS e
        LEFT JOIN
    department AS d ON d.dept_id = e.department_id
WHERE d.dept_id IS NULL;

--Q 6 — Second highest salary in each department?

SELECT *
FROM (
    SELECT 
        emp_name, 
        salary, 
        department_id, 
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM emp
) AS a
WHERE rn = 2;

--Q — 7 : Find all the transactions done by customer named Pradeep.

SELECT *
FROM orders
WHERE UPPER (customer_name) = 'PRADEEP';

--WHERE UPPER(customer_name) = 'PRADEEP': This is the filtering condition.
--ensuring case sensitive comparison


-- Q — 8 : Self Join, manager salary > employee salary?

SELECT
    e1.emp_id,
    e1.emp_name,
    e2.emp_name AS manager_name,
    e1.salary,
    e2.salary AS manager_salary
FROM
    emp AS e1
INNER JOIN
    emp AS e2 ON e1.manager_id = e2.emp_id
WHERE e2.salary > e1.salary;


--Q — 10 : Update query to swap gender?
UPDATE orders 
SET 
    customer_gender = CASE
        WHEN customer_gender = 'Male' THEN 'Female'
        WHEN customer_gender = 'Female' THEN 'Male'
    END

SELECT *
FROM orders