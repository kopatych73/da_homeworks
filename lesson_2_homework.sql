--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing


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
SELECT outcomes.ship FROM outcomes
join battles 
on outcomes.battle = battles.name
where result = 'sunk'
and date = 
(
SELECT max(date) FROM outcomes
join battles 
on outcomes.battle = battles.name
where result = 'sunk'
)

-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������
--
SELECT outcomes.ship, class FROM outcomes
join battles 
on outcomes.battle = battles.name
join ships 
on ships."name" = outcomes.ship 
where result = 'sunk'
and date = 
(
SELECT date FROM outcomes
join battles 
on outcomes.battle = battles.name
join ships 
on ships."name" = outcomes.ship 
where result = 'sunk'
)

-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class
--
select o.ship , c."class"  
from outcomes o 
join ships s
on s."name" = o.ship 
join classes c
on c."class"  = s."class" 
where "result" = 'sunk'
and bore >=16

-- ������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class
--
select class from classes c 
where country = 'USA'

-- ������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class

select name, classes.class from ships s 
join classes 
on classes."class"  = s."class" 
where country = 'USA'