-- homework 26/05/2022

select * from ships


-- ������� 1: ������� name, class �� ��������, ���������� ����� 1920
--
select name, class from ships
where launched > 1920

-- ������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942
--
select name, class from ships
where launched between 1920 and 1942


-- ������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class
--

select class, count(class)
from ships 
group by class 


-- ������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)
--

select class, country  from classes
where bore >=16


-- ������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.
--
select ship from outcomes o 
where result = 'sunk'
and battle = 'North Atlantic' 


-- ������� 6: ������� �������� (ship) ���������� ������������ �������
--
select *--ship  
from outcomes o 
join battles b 
on b."name" =o.battle
where o.result = 'sunk'
and b.date = 
(
select max(date) from outcomes o 
join battles b 
on b."name" =o.battle
where o.result = 'sunk'
)

-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������
--
select * from ships s 

select * from ships s
join outcomes o 
on s."name" = o.ship
join battles b 
on b."name" =  o.battle 
where result 


select * from outcomes o
where "result" ='sunk'


select *from battles b 

select *from battles b
join outcomes o 
on o.battle = b."name" 
join ships s 
on s."name" = o.ship  
where result = 'sunk'

select * from outcomes o
join battles b 
on o.battle = b."name"
join ships s  
on s.name = o.ship 
where result = 'sunk'
and b."date" =
(select max(date) from battles b
join outcomes o
on b."name" = o.battle
where result = 'sunk')



-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class
--

-- ������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class
--

-- ������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class