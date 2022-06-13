--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--�������: ��� ������� ������ ���������� ����� �������� ����� ������, 
--����������� � ���������. �������: ����� � ����� ����������� ��������.

select class, count(ship) from ships s 
join 
	outcomes o 
on s."name" =o.ship 
	where o."result" = 'sunk'
	group by "class" 


--task2
--�������: ��� ������� ������ ���������� ���, ����� ��� ������ �� ���� ������ ������� ����� ������. ���� ��� ������ �� ���� ��������� ������� ����������, ���������� ����������� ��� ������ �� ���� �������� ����� ������. �������: �����, ���.

select c."class" , l from classes c
join 
	(select class, min(launched) l from ships s 
	group by "class") ml
on  ml.class = c."class" 

--task3
--�������: ��� �������, ������� ������ � ���� ����������� �������� � �� ����� 3 �������� � ���� ������, ������� ��� ������ � ����� ����������� ��������.

with sunked_ships as
	(select class, count(ship) sunked from ships
	join 
	(select * from outcomes o 
	where result='sunk') su
	on ships."name" = su.ship
	group by class)
select more_then_2.class, sunked_ships.sunked from sunked_ships
join 
	(select class, count(name) from ships s2
	group by "class" 
	having count(name)>2) more_then_2
on more_then_2.class = sunked_ships."class" 


--task4
--�������: ������� �������� ��������, ������� ���������� ����� ������ 
--����� ���� �������� ������ �� ������������� (������ ������� �� ������� Outcomes).

with max_numgun as (
select displacement, max(numguns ) from classes c
group by displacement)
,
allships as
(select name, "class" from ships 
join outcomes 
on ships."name" = outcomes.ship) 
select name from classes cl
join max_numgun m
on m.displacement = cl.displacement 
join allships alls
on alls.class = cl."class" 

--task5
--������������ �����: ������� �������������� ���������, 
--������� ���������� �� � ���������� ������� RAM � 
--� ����� ������� ����������� ����� ���� ��, ������� 
--���������� ����� RAM. �������: Maker

with minram as (
select pc.model, min(ram) from pc
join  
	(select model, max(speed) 
	from pc
	where ram = 
	(select min(ram)
	from pc) 
	group by model) maxspeed
on pc.model=maxspeed.model
group by pc.model)
select distinct maker from product
where maker in (
select maker from product
join minram
on minram.model = product.model)
and type='Printer'





with mkrprinter as 
(
select distinct maker from product
where type = 'Printer'
)




select * 
from pc
join product 
on product.model = pc.model
join printer 
on printer.maker = product.maker 
where ram = 
(select min(ram)
from pc)


join product 
--on printer.model = product.model 

--group by model
