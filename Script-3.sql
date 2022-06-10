
--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing


--task1
--������������ �����: ������� ������� ���� ���� ���������, �������������� �� ��������������.
--�����: ����, �������������
with all_prod as
(
select model, price from pc p 
union all
select model, price from laptop l 
union all
select model, price from printer p2 
)
select avg(price), maker from all_prod a
join product p
on a.model = p.model 
group by maker
order by maker



--task2
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL).
select * from ships
where class is null 



--task3
--������������ �����: ����� �����������/�������������� �����������, ������� ������� ��� � ������� (�� ���� ������ ���� ����������� ����������� � ������� PC)


with model_pc as 
(
	select model from pc 
	
) 
select * from product
where model not in
(select model from model_pc)
and type = 'PC'

	
	-- ���������� ���:
with model_pc_exists as (
	select distinct model 
	from pc
)
select * --distinct maker 
from product 
where model not in (select model from model_pc_exists)
	


--task4
--������������ �����: ����� ������ � ���� ����������� �����������, ��������� ������� ��������� ��������� ������ ��

select model, price from laptop where price > any (select price from pc)



--task5 +++
--������������ �����: ������� ����� ������ �������� (��, ��-�������� ��� ��������), �������� ����� ������� ����. �������: model
with all_prod as 
(
	select model, price from pc p 
	union all
	select model, price from laptop l
	union all
	select model, price from printer p2 
)
select model from all_prod where 
price = (select max(price) from all_prod)


--task6
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ������ 300 - "1", � ��������� - "0"

select *,
case 
	when price>300 then 1
	else 0
end flag
from printer p 

--task7
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� - "1", � ��������� - "0"
select *,
case 
	when price> (select avg(price) from printer) then 1
	else 0
end flag
from printer p 



--task9
--������������ �����: ������� ������ ���� ���������� PC � ������������� � ����� ���� ���� �� ������ ��������. �����: model, maker

select distinct  product.model, maker from pc
join
product
on pc.model =product.model 
where price > any (select price from printer)

--task10
--������������ �����: ������� ������ ���� ���������� ��������� � ������������� � ������ ��. ������� model, maker

select distinct maker, model 
from product


--task11
--�������: ������� ������ ���� �������� � �����. ��� ��� � ���� ��� ������ - ������� 0, ��� ��������� - class

with t0 as
(
select ship from outcomes
  union
select name from ships
)
select * from t0
left join ships s
on s.ship = t0.ship


--task12
--�������: ��� ������� ������ ���������� ���, ����� ��� ������ �� ���� ������ ������� ����� ������. �������: �����, ���


--task13
--������������ �����: ������� ������ ���� ��������� � �������������� � ��������� ���� �������� (pc, printer, laptpo). �������: model, maker, type

--task14
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"


select *,
case
	when price > (select avg(price) from pc) then 1
	else 0
end flag
 from printer p


--task15
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)

--task16
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����. (����� with)

--task17
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.
 
select battle 
from outcomes o 
 join ships s 
on s.name = o.ship 
where class = 'Kongo'
 
 
