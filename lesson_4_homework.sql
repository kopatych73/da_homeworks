--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

-- что то не так с условием?
select model, maker, type from product p 


--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
case 
	when price > (select avg(price) from pc) then 1
	else 0
end flag
from printer p 

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select allsh.name from 
(select name from ships s 
union 
select ship from outcomes o ) allsh
left join ships
on allsh.name = ships."name" 
where class is null 


--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

select b."name" , date_part('year', b."date")  from battles b 
where date_part('year', b."date") not in 
(select launched from ships s)

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select * from ships s 
join outcomes o 
on o.ship  = s."name" 
where "class" = 'Kongo'

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag

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
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag


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
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with allprint as
(select p.*, p2.maker from printer p 
join product p2 
on p.model =p2.model)
select model from allprint
where maker = 'A'
and price > (select avg(price) from allprint where maker = 'D' or maker = 'C')


--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

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
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

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
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

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
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

request = """ 
select * from count_products_by_makers order by maker
""" 
df = pd.read_sql_query(request, conn) 
fig = px.bar(x=df.maker.to_list(), y=df['count'].to_list(), labels={'x':'maker', 'y':'avg price'}) 
fig.show()

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

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
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers
as
(select pd.*, p.maker  from printer_updated pd
join product p
on p.model=pd.model)

select * from printer_updated_with_makers

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

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
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

request = "select * from sunk_ships_by_classes" 
df = pd.read_sql_query(request, conn) 
fig = px.bar(x=df['class'].to_list(), y=df['count'].to_list(), labels={'x':'class', 'y':'count'}) 
fig.show()


--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

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
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

request = """
select country, count(*) from classes c 
group by country 
""" 
df = pd.read_sql_query(request, conn) 
fig = px.bar(x=df['country'].to_list(), y=df['count'].to_list(), labels={'x':'year', 'y':'count'}) 
fig.show()

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

SELECT count(*) FROM ships
where name like 'O%'
or name like 'M%'

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

SELECT count(name) FROM ships
where name like '__'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

request = """
select launched as year, count(*) as count from ships s 
group by launched 
""" 
df = pd.read_sql_query(request, conn) 
fig = px.bar(x=df['year'].to_list(), y=df['count'].to_list(), labels={'x':'year', 'y':'count'}) 
fig.show()

