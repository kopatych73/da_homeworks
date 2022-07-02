--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

select Department, Employee, salary
--DENSE_RANK() OVER(PARTITION BY Department ORDER BY Salary desc) as rnk
from
(
select Department.name as Department,
Employee.name as Employee,
salary,
DENSE_RANK() OVER(PARTITION BY  Department.name ORDER BY Salary desc) as rnk
from Employee
join Department
on Employee.departmentId  = Department.id
) a
where rnk < 4


--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

select member_name, status,  sum(amount*unit_price) as costs 
from FamilyMembers fm
join Payments pm
on fm.member_id = pm.family_member
where YEAR(date) = 2005
group by (fm.member_id)


--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

select name
from passenger
group by name
having count(name)>1

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name) as COUNT
from student
where first_name = 'Anna'
group by first_name

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35


select count(classroom) as count
from Schedule
where date = '2019-09-02'


--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

Дубль задачи выше

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

select floor(avg(year(current_date) - year(birthday))) as age
FROM familymembers

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

 select good_type_name, 
 sum(amount*unit_price) as costs 
 from GoodTypes 
 join Goods on good_type_id = type 
 join Payments on good = good_id 
 and year(date) = 2005 
 group by good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37


select floor(datediff(current_date,max(birthday))/365) as year from student


--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

 select  
 floor(datediff(current_date,min(birthday))/365) as max_year 
 from Student 
 join Student_in_class 
 on Student.id=Student_in_class.student 
 join Class 
 on Class.id=Student_in_class.class 
 where Class.name LIKE '10%'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

select status, member_name, sum(unit_price*amount) as costs 
from familymembers as fm 
join payments as p 
on fm.member_id = p.family_member 
join goods as g 
on p.good = g.good_id 
join goodtypes as gt
on g.type = gt.good_type_id 
where good_type_name = 'entertainment' 
group by family_member

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

delete from company 
where name in (
select name from 
(
    select name,
    rank() over(order by cnt) as rnk FROM 
    (
        select name, count(*) as cnt
        from trip
        join company 
        on company.id=trip.company
        group by name
    ) as a 
) as b
where rnk = 1
)


--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

select  classroom FROM 
(
	select 
	classroom,count,
	rank() over(order by count desc) as rnk
	from
	(
		SELECT classroom, COUNT(classroom) as count 
		FROM Schedule 
		GROUP BY classroom 
	) as a
) as b
where rnk=1

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

select last_name 
from teacher 
join Schedule
on teacher.id=Schedule.teacher 
join subject 
on subject.id=Schedule.subject
where subject.name = 'Physical Culture'
order by last_name



--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

select 
concat(last_name, '.', 
left(first_name, 1), '.', 
left(middle_name, 1), '.') 
as name 
from student 
order by last_name,first_name
