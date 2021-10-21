/*
This is a prcatice set from 
https://www.w3schools.com/sql/sql_exercises.asp
*/

--Select
--1. Write a query to display the name (first_name, last_name) and salary for all employees whose salary is not in the range $10,000 through $15,000. Go to the editor
select first_name,last_name,salary
from Gianni.dbo.employees
where salary not between 10000 and 15000

--7. Write a query to display the last name of employees whose names have exactly 6 characters. Go to the editor
select last_name
from Gianni.dbo.employees
where LEN(last_name) = 6

--8. Write a query to display the last name of employees having 'e' as the third character. Go to the editor
select last_name
from Gianni.dbo.employees
where last_name like '__e'

--Subquery
--1. Write a query to find the name (first_name, last_name) and the salary of the employees who have a higher salary than the employee whose last_name='Bull'. Go to the editor
select 
first_name,
last_name,
salary 
from Gianni.dbo.employees
where salary > 
(select salary from Gianni.dbo.employees where last_name like 'Bull');

--2. Write a query to find the name (first_name, last_name) of all employees who works in the IT department. Go to the editor
select first_name,last_name
from employees
where department_id in
(select department_id from department where department_name like 'IT')

--3. Write a query to find the name (first_name, last_name) of the employees who have a manager and worked in a USA based department. Go to the editor
--Hint : Write single-row and multiple-row subqueries
select first_name,last_name from employees
where manager_id in (select manager_id 
from department where location_id in ( 
select location_id from locations where country_id like 'US'))
order by first_name

SELECT first_name, last_name FROM employees 
WHERE manager_id in (select employee_id 
FROM employees WHERE department_id 
IN (SELECT department_id FROM department WHERE location_id 
IN (select location_id from locations where country_id='US')))
order by first_name

--4. Write a query to find the name (first_name, last_name) of the employees who are managers. Go to the editor
select first_name,last_name
from employees
where employee_id in (select manager_id from employees)

--5. Write a query to find the name (first_name, last_name), and salary of the employees whose salary is greater than the average salary. Go to the editor
select first_name,last_name,salary 
from gianni.dbo.employees
where salary > (select AVG(salary) from employees)

--6. Write a query to find the name (first_name, last_name), and salary of the employees whose salary is equal to the minimum salary for their job grade. Go to the editor
SELECT first_name, last_name, salary 
FROM employees 
WHERE salary = (SELECT min_salary
FROM jobs
WHERE employees.job_id = jobs.job_id);


--7. Write a query to find the name (first_name, last_name), and salary of the employees who earns more than the average salary and works in any of the IT departments. Go to the editor
select first_name,last_name, salary
from employees
where DEPARTMENT_ID in (select department_id from department where department_name ='IT') and 
	  SALARY > (select AVG(salary) from employees) 

--8. Write a query to find the name (first_name, last_name), and salary of the employees who earns more than the earning of Mr. Bell. Go to the editor
select first_name, last_name,salary from employees
where salary >
(select salary from employees where last_name = 'Bell') 
order by FIRST_NAME

--9. Write a query to find the name (first_name, last_name), and salary of the employees who earn the same salary as the minimum salary for all departments. Go to the editor
select first_name, last_name from employees
where salary =
(select min(salary) from employees)

--10. Write a query to find the name (first_name, last_name), and salary of the employees whose salary is greater than the average salary of all departments. Go to the editor
SELECT * FROM employees 
where salary > ALL(SELECT avg(salary)FROM employees GROUP BY department_id);

--11. Write a query to find the name (first_name, last_name) and salary of the employees who earn a salary that is higher than the salary of all the Shipping Clerk (JOB_ID = 'SH_CLERK'). Sort the results of the salary of the lowest to highest. 
select first_name,last_name, salary
from employees
where salary > ALL ( select salary from employees where JOB_ID = 'SH_CLERK') order by SALARY

--12. Write a query to find the name (first_name, last_name) of the employees who are not supervisors. Go to the editor
select first_name, last_name from employees where employee_id not in 
(select manager_id from employees)

--13. Write a query to display the employee ID, first name, last name, and department names of all employees. Go to the editor
select employee_id, first_name, last_name, department_name
from employees e
left join department d on e.DEPARTMENT_ID = d.DEPARTMENT_ID

select employee_id, first_name, last_name, (select department_name from department d where e.DEPARTMENT_ID = d.DEPARTMENT_ID) department
from employees e
order by department

--14. Write a query to display the employee ID, first name, last name, salary of all employees whose salary is above average for their departments. 
SELECT employee_id, first_name 
FROM employees 
WHERE salary > 
(SELECT AVG(salary) FROM employees WHERE department_id = employees.department_id) 
group by DEPARTMENT_ID;

SELECT employee_id, first_name 
FROM employees 
WHERE salary > 
(select AVG(salary) FROM employees)

--String
--1. Write a query to get the job_id and related employee's id. Go to the editor
select job_id, string_agg (employee_id,' ')
from employees
group by job_id

--2. Write a query to update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'.
UPDATE employees 
SET phone_number = REPLACE(phone_number, '124', '999') 
WHERE phone_number LIKE '%124%';


