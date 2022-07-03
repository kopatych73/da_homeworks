--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select 
case 
when g.grade > 7 then name
else NULL
end as name,
g.grade, marks from students as s 
join grades as g 
on s.marks between g.min_mark and g.max_mark
order by g.grade desc, name, marks
;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

Решение посмотрел в интернете. Самостоятельно не смог разобраться. Слишком жестокое условие...

set @d=0, @p=0, @s=0, @a=0;

select min(Doctor), min(Professor), min(Singer), min(Actor)
from(
  select case 
            when Occupation='Doctor' then (@d:=@d+1)
            when Occupation='Professor' then (@p:=@p+1)
            when Occupation='Singer' then (@s:=@s+1)
            when Occupation='Actor' then (@a:=@a+1) 
            end as Rowline,
        case when Occupation='Doctor' then Name end as Doctor,
        case when Occupation='Professor' then Name end as Professor,
        case when Occupation='Singer' then Name end as Singer,
        case when Occupation='Actor' then Name end as Actor
  from OCCUPATIONS
order by Name
) as temp
group by Rowline;
;



--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct city from STATION
Where left(city, 1) not in
('A','E','I','O','U')


--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city from STATION
Where right(city, 1) not in
('A','E','I','O','U')


--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct city from STATION
Where right(city, 1) not in
('A','E','I','O','U')
or
left(city, 1) not in
('A','E','I','O','U')

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct city from STATION
Where right(city, 1) not in
('A','E','I','O','U')
and
left(city, 1) not in
('A','E','I','O','U')

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name from Employee 
where salary > 2000 and months < 10

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

Дубль task1