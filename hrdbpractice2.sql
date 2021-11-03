--1. Display the name for those employees who gets more salary than the employee whose id is 163
select FIRST_NAME,LAST_NAME
from dbo.employees
where salary > (select salary
from dbo.employees 
where EMPLOYEE_ID = 163)

--2. From the following table, write a SQL query to find those employees whose designation is the same as the employee whose ID is 169. Return first name, last name, department ID and job ID.
select  FIRST_NAME, LAST_NAME, DEPARTMENT_ID, JOB_ID
from dbo.employees
where JOB_ID = (select JOB_ID
from dbo.employees 
where EMPLOYEE_ID = 169)
and DEPARTMENT_ID =(select DEPARTMENT_ID
from dbo.employees 
where EMPLOYEE_ID = 169)

--3. From the following table, write a SQL query to find those employees whose salary matches the smallest salary of any of the departments. Return first name, last name and department ID.  
select FIRST_NAME, LAST_NAME, DEPARTMENT_ID
from employees
where salary in (select min(salary)
from employees
group by DEPARTMENT_ID)

--5. From the following table, write a SQL query to find those employees who report that manager whose first name is ‘Payam’. Return first name, last name, employee ID and salary. 
select FIRST_NAME,LAST_NAME,EMPLOYEE_ID, SALARY
from employees
where manager_id =
(select EMPLOYEE_ID
from employees 
where FIRST_NAME = 'Payam')

--6. From the following tables, write a SQL query to find all those employees who work in the Finance department. Return department ID, name (first), job ID and department name. 
select e.DEPARTMENT_ID,FIRST_NAME,JOB_ID,DEPARTMENT_NAME
from employees e, department d
where e.DEPARTMENT_ID = d.DEPARTMENT_ID and DEPARTMENT_NAME = 'Finance'


--10. From the following table and write a SQL query to find those employees whose salary is in the range of smallest salary, and 2500. Return all the fields.
select *
from employees
where salary between (select min(salary)
from employees) and 2500

--11. From the following tables, write a SQL query to find those employees who do not work in those departments where manager ids are in the range 100, 200 
--(Begin and end values are included.) Return all the fields of the employees.
select *
from employees
where DEPARTMENT_ID not in (
select DEPARTMENT_ID
from department where MANAGER_ID between 100 and 200)

--12. From the following table, write a SQL query to find those employees who get second-highest salary. Return all the fields of the employees. 
select *
from employees where salary =
(select top 1 salary
from
(select top 2 salary 
from employees order by salary desc) as Tabletop2
order by salary)

--16. From the following table, write a SQL query to find those employees whose department located at 'Toronto'. Return first name, last name, employee ID, job ID. 
select FIRST_NAME,LAST_NAME,EMPLOYEE_ID, JOB_ID
from employees
where department_id =
(select DEPARTMENT_ID
from department where LOCATION_ID = (
select LOCATION_ID
from locations
where city = 'Toronto'))

--17. From the following table, write a SQL query to find those employees whose salary is lower than any salary of those employees whose job title is ‘MK_MAN’. Return employee ID, first name, last name, job ID.
select *
from employees
where salary < (
select salary
from employees
where JOB_ID = 'MK_MAN')

--20. From the following table, write a SQL query to find those employees whose salary is more than average salary of any department. Return employee ID, first name, last name, job ID. 
select *
from employees 
where salary > all
(select (AVG (salary))
from employees
group by DEPARTMENT_ID)

--From the following table, write a SQL query to find total salary of those departments where at least one employee works. Return department ID, total salary.
select department.department_id,result1.total_amt
from department, 
(select sum(salary) total_amt, DEPARTMENT_ID
from employees
group by DEPARTMENT_ID) result1
where result1.DEPARTMENT_ID = department.DEPARTMENT_ID

--24. Write a query to display the employee id, name ( first name and last name ), 
--salary and the SalaryStatus column with a title HIGH and LOW respectively for those employees whose salary is more than and less than the average salary of all employees.
select EMPLOYEE_ID, concat(FIRST_NAME,' ',LAST_NAME), SALARY, case 
when salary > (select avg(salary) from employees) then 'High'
when salary < (select avg(salary) from employees) then 'Low'
end as salarystatus
from employees

--26. From the following table, write a SQL query to find all those departments where at least one or more employees work.Return department name. 
select DEPARTMENT_NAME
from department d
where d.DEPARTMENT_ID in
(select distinct DEPARTMENT_ID
from employees e)

-- 27. From the following tables, write a SQL query to find those employees who work in departments located at 'United Kingdom'. Return first name. 
select FIRST_NAME
from employees
where DEPARTMENT_ID in(
select DEPARTMENT_ID
from department
where LOCATION_ID in
(select location_id
from locations where COUNTRY_ID =
(select COUNTRY_ID
from country where COUNTRY_NAME ='United Kingdom')))

--30. From the following tables, write a SQL query to find those employees who work under a manager based in ‘US’. Return first name, last name. 
select FIRST_NAME,LAST_NAME
from employees
where MANAGER_ID in(
select employee_id
from employees where DEPARTMENT_ID in (
select department_id
from department where location_id in 
(select LOCATION_ID
from locations
where COUNTRY_ID = 'US')))

--31. From the following tables, write a SQL query to find those employees whose salary is greater than 50% of their department's total salary bill. Return first name, last name. 
select first_name,last_name
from employees e,
(select (sum(salary) * 0.5)sumsalary, DEPARTMENT_ID
from employees
group by DEPARTMENT_ID) as ed
where SALARY > sumsalary and e.DEPARTMENT_ID=ed.DEPARTMENT_ID

--33. From the following table, write a SQL query to find those employees who manage a department. Return all the fields of employees table.
select *
from employees
where employee_id in
(select MANAGER_ID
from department)

--42. From the following table, write a SQL query to find those employees who earn more than the minimum salary of a department of ID 40. Return first name, last name, salary, and department ID. 
select FIRST_NAME,LAST_NAME,SALARY,DEPARTMENT_ID
from employees 
where salary >
(select min(salary)
from employees
where DEPARTMENT_ID = 40)

--49. From the following tables, write a SQL query to find those departments where starting salary is at least 8000. Return all the fields of departments.  
select *
from department dep1, (select min(salary) startsalary,DEPARTMENT_ID
from employees
group by DEPARTMENT_ID) dep2
where dep1.DEPARTMENT_ID = dep2.DEPARTMENT_ID and startsalary >= 8000

SELECT * FROM department 
	WHERE department_id IN 
		( SELECT department_id 
                   FROM employees 
			GROUP BY department_id 
				HAVING MIN(salary)>=8000);

--50. From the following table, write a SQL query to find those managers who supervise four or more employees. Return manager name, department ID.
select concat(FIRST_NAME,' ',LAST_NAME) managername, DEPARTMENT_ID
from employees where employee_id in
(select MANAGER_ID
from employees
group by MANAGER_ID
having COUNT(MANAGER_ID)>4)

select concat(FIRST_NAME,' ',LAST_NAME) managername, DEPARTMENT_ID
from employees
where employee_id in(
(select distinct temp.MANAGER_ID
from employees e,
(select count(EMPLOYEE_ID) counts,MANAGER_ID
from employees
group by MANAGER_ID) as temp
where counts > 4))

--52. From the following table, write a SQL query to find those employees who earn second-lowest salary of all the employees. Return all the fields of employees.
SELECT * 
FROM employees
WHERE SALARY = (
select top 1 TOP2.SALARY
from (select top 2 SALARY
from employees
order by SALARY) AS TOP2
ORDER BY SALARY DESC)

--53. From the following table, write a SQL query to find those departments managed by ‘Susan’. Return all the fields of departments. 
select *
from department
where MANAGER_ID in
(select EMPLOYEE_ID
from employees
where FIRST_NAME = 'Susan')

--54. From the following table, write a SQL query to find those employees who earn highest salary in a department. Return department ID, employee name, and salary.
select e.department_id, concat(first_name,' ', last_name) name, SALARY
from employees e,
(select max(SALARY) maxsalary, DEPARTMENT_ID
from employees
group by department_id) as topsalarytbl
where SALARY=maxsalary and e.DEPARTMENT_ID = topsalarytbl.DEPARTMENT_ID

--for fun wite SQL query who earn 2nd highest salary from each department
with CTE as
(select DEPARTMENT_ID, salary, row_number() over (partition by department_id order by salary) rownum
from employees)
select *
from CTE
where rownum = 2


--55. From the following table, write a SQL query to find those employees who did not have any job in the past. Return all the fields of employees.   Go to the editor
select *
from employees
where employee_id not in (select EMPLOYEE_ID
from job_history)

























