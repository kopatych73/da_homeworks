--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� � ��������� ���� �������� (pc, printer, laptop). �������: model, maker, type

-- ��� �� �� ��� � ��������?
select model, maker, type from product p 


--task14 (lesson3)
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"

select *,
case 
	when price > (select avg(price) from pc) then 1
	else 0
end flag
from printer p 

--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)

select allsh.name from 
(select name from ships s 
union 
select ship from outcomes o ) allsh
left join ships
on allsh.name = ships."name" 
where class is null 


--task16 (lesson3)
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����.

select b."name" , date_part('year', b."date")  from battles b 
where date_part('year', b."date") not in 
(select launched from ships s)

--task17 (lesson3)
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.

select * from ships s 
join outcomes o 
on o.ship  = s."name" 
where "class" = 'Kongo'

--task1  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_300) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ > 300. �� view ��� �������: model, price, flag

--drop view all_products_flag_300

create view all_products_flag_300
as
(select model, price,
case when price > 300 then 1
else 0
end flag from
	(
	select model, price from pc
	union all
	select model, price from laptop
	union all
	select model, price from printer
	) foo
)


--task2  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_avg_price) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ c������ . �� view ��� �������: model, price, flag


--drop view all_products_flag_avg_price

create view all_products_flag_avg_price as
with allp as
	(select model, price from pc
	union all
	select model, price from laptop
	union all
	select model, price from printer)
select model, price,
case when price > (select avg(price) from allp) then 1
else 0
end flag from allp

select * from all_products_flag_avg_price


--task3  (lesson4)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

with allprint as
(select p.*, p2.maker from printer p 
join product p2 
on p.model =p2.model)
select model from allprint
where maker = 'A'
and price > (select avg(price) from allprint where maker = 'D' or maker = 'C')


--task4 (lesson4)
-- ������������ �����: ������� ��� ������ ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

with allp as
	(select model, price from pc
	union all
	select model, price from laptop
	union all
	select model, price from printer)
	,
	allprint as
		(select p.*, p2.maker from printer p 
		join product p2 
		on p.model =p2.model)
select * from allp
join product p2
on allp.model = p2.model 
where maker = 'A'
and price > (select avg(price) from allprint where maker = 'D' or maker = 'C')

--task5 (lesson4)
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (printer & laptop & pc)

with allp as
	(select model, price from pc
	union all
	select model, price from laptop
	union all
	select model, price from printer)
select avg(price) from allp
join product 
on allp.model=product.model 
where maker = 'A'
 

--task6 (lesson4)
-- ������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) �� ������� �������������. �� view: maker, count

create view count_products_by_makers as
with allp as
	(select model, price from pc
	union all
	select model, price from laptop
	union all
	select model, price from printer)
select maker, count(*) from allp
join product 
on allp.model = product.model 
group by product.maker 

select * from count_products_by_makers


--task7 (lesson4)
-- �� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)

request = """ 
select * from count_products_by_makers order by maker
""" 
df = pd.read_sql_query(request, conn) 
fig = px.bar(x=df.maker.to_list(), y=df['count'].to_list(), labels={'x':'maker', 'y':'avg price'}) 
fig.show()

--task8 (lesson4)
-- ������������ �����: ������� ����� ������� printer (�������� printer_updated) � ������� �� ��� ��� �������� ������������� 'D'

--drop table printer_updated

create table printer_updated
as
(select * from printer)

delete from printer_updated
where model in 
(select pd.model from printer_updated as pd
	join product as p2 
on pd.model =p2.model
where p2.maker = 'D')

--task9 (lesson4)
-- ������������ �����: ������� �� ���� ������� (printer_updated) view � �������������� �������� ������������� (�������� printer_updated_with_makers)

create view printer_updated_with_makers
as
(select pd.*, p.maker  from printer_updated pd
join product p
on p.model=pd.model)

select * from printer_updated_with_makers

--task10 (lesson4)
-- �������: ������� view c ����������� ����������� �������� � ������� ������� (�������� sunk_ships_by_classes). �� view: count, class (���� �������� ������ ���/IS NULL, �� �������� �� 0)

drop view sunk_ships_by_classes

create view sunk_ships_by_classes as
(select class_ as class, count(class_)  from
(
	select ship, 
	case
		when (s."class" is null) then '0'
		else class
	end class_
	from outcomes o 
	left join ships s 
	on o.ship =s."name" 
	where result = 'sunk'
) a
group by class_)

select * from sunk_ships_by_classes


--task11 (lesson4)
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)

request = "select * from sunk_ships_by_classes" 
df = pd.read_sql_query(request, conn) 
fig = px.bar(x=df['class'].to_list(), y=df['count'].to_list(), labels={'x':'class', 'y':'count'}) 
fig.show()


--task12 (lesson4)
-- �������: ������� ����� ������� classes (�������� classes_with_flag) � �������� � ��� flag: ���� ���������� ������ ������ ��� ����� 9 - �� 1, ����� 0

create table classes_with_flag
as
(select *,
case 	
	when c.numguns >=9 then 1
	else 0
end flag
from classes c 
)

select * from classes_with_flag

--task13 (lesson4)
-- �������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)

request = """
select country, count(*) from classes c 
group by country 
""" 
df = pd.read_sql_query(request, conn) 
fig = px.bar(x=df['country'].to_list(), y=df['count'].to_list(), labels={'x':'year', 'y':'count'}) 
fig.show()

--task14 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".

SELECT count(*) FROM ships
where name like 'O%'
or name like 'M%'

--task15 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.

SELECT count(name) FROM ships
where name like '__'

--task16 (lesson4)
-- �������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)

request = """
select launched as year, count(*) as count from ships s 
group by launched 
""" 
df = pd.read_sql_query(request, conn) 
fig = px.bar(x=df['year'].to_list(), y=df['count'].to_list(), labels={'x':'year', 'y':'count'}) 
fig.show()

