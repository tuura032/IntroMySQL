MySQL Topic 4 Coding Assignment
_______________________________

1) call limit_employees(int);

// selects all columns from employees, and returns # of rows equal to user input

CREATE PROCEDURE limit_employees(IN var1 INT)
    select * from employees limit var1;
    //

-----------------------------------------------------------------------------------------

2) call birthdays('YYYY-MM-DD');

// selects all people with a given birthdate

CREATE PROCEDURE birthdays(IN date date)
select * from employees where birth_date = date;

---------------------------------------------------------------------------------------------

3) call highest_salary_by_department("Department");

// selects name, dept, salary, and date of highest paid employee from that department

CREATE PROCEDURE highest_salary_by_department( IN input_dept VARCHAR(20))
select e.first_name, e.last_name, d.dept_name, s.salary, s.from_date from employees e
INNER JOIN dept_emp de ON de.emp_no = e.emp_no
INNER JOIN departments d ON d.dept_no = de.dept_no
INNER JOIN salaries s ON s.emp_no = e.emp_no
WHERE d.dept_name = input_dept && salary = (select max(s.salary) from salaries s 
inner join dept_emp de on de.emp_no = s.emp_no
inner join departments d on d.dept_no = de.dept_no
WHERE d.dept_name = input_dept);

-------------------------------------------------------------------------------------------------

4) call return_highest_salary_by_department("department", @high_salary);

// return just the highest salary of the department


CREATE PROCEDURE return_highest_salary_by_department( IN input_dept VARCHAR(20), OUT high_salary INT)
select s.salary
into high_salary
from salaries s
INNER JOIN dept_emp de ON de.emp_no = s.emp_no
INNER JOIN departments d ON d.dept_no = de.dept_no
WHERE d.dept_name = input_dept && salary = (select max(s.salary) from salaries s 
inner join dept_emp de on de.emp_no = s.emp_no
inner join departments d on d.dept_no = de.dept_no
WHERE d.dept_name = input_dept);

--------------------------------------------------------------------------------------------------

5) call is_paid_enough(IN emp_id int(11), OUT answer varchar(3);

// input an employee id, output answer to if they are paid enough or not

CREATE PROCEDURE is_paid_enough(IN emp_id int(11), OUT answer varchar(3))
BEGIN
DECLARE test_salary int;
SELECT max(salary) into test_salary from salaries where emp_no = emp_id;
if test_salary > 50000 THEN SET answer = "yes";
else SET answer = "no";
END IF;
END //

delimiter ;

select @answer;

-------------------------------------------------------------------------------------------------------

6) call test_loop;

// selects string str, which is created by concatenating the value of a counter to string in a loop. 
// This example is from mysqltutorial, because frankly I can't think of a good reason to use a loop in sql. 

CREATE PROCEDURE test_loop()
BEGIN
DECLARE x INT;
DECLARE str VARCHAR(255);

SET x = 1;
SET str = '';

WHILE x <= 5 DO
SET str = CONCAT(str,x,',');
SET x = x + 1;
END WHILE;

SELECT str;
END//

----------------------------------------------------------------------------------------------------------------------------

7) call lifetime_earnings_sum(emp_no);

// calculates employee lifetime earnings, taking emp_no as input. Instead of using sum(), I recreated that function using a loop. 
// This took a long time, but I learned a lot. 
// It probably won't work if an employee had gap years in pay, which I could fix with some IF checks.

DROP PROCEDURE IF EXISTS lifetime_earnings;
CREATE PROCEDURE lifetime_earnings(IN emp_id int(11))
BEGIN

DECLARE current_salary int(11);
DECLARE total_earnings int(11);
DECLARE current_year INT unsigned;
DECLARE last_year INT unsigned;

SELECT cast(year(from_date) AS unsigned) into current_year from salaries where emp_no = emp_id order by from_date limit 1;
SELECT cast(year(from_date) AS unsigned) into last_year from salaries where emp_no = emp_id order by from_date desc limit 1;

SET total_earnings = 0;

WHILE current_year <= last_year DO
SELECT salary into current_salary from salaries where emp_no = emp_id and cast(year(from_date) AS unsigned) = current_year;
SET total_earnings = total_earnings + current_salary;
SET current_year = current_year + 1;
END WHILE;

SELECT total_earnings;
END//


-----------------------


