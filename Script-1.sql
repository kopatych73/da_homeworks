-- Задание 9: Посчитать количество возможных типов cd в таблице PC

select count(distinct cd) from pc

-- Задание 10: Какое количество принтеров у каждого производителя (maker), стоимость (price) которых (принтера) больше 280

select maker, count(*)   from product p 
join
printer p2 
on p.model = p2.model 
where price > 280
group by maker 

-- Задание 11: Найти модели принтеров с самой высокой ценой. Вывести: model, price

select model, price from printer p
where price = (select max(price) from printer p) 

--
-- Задание 12: Вывести разницу в средней цене между PC и принтерами (Printer)
--
select ((select avg(price) from printer) - (select avg(price) from pc)) as diff

-- Задание 13: Вывести производителей самых дешевых принтеров. Вывести price, maker
--
select maker,price from product p
join
printer p2
on p.model = p2.model 
where price = (select min(price) from printer p)

-- Задание 14: Вывести производителей самых дешевых цветных принтеров (color = 'y')
--
select maker 
from product 
join printer 
on product.model = printer.model 
where price = (select min(price) from  printer where color = 'y' ) 
and color = 'y'

-- Задание 15: Вывести все принтеры со стоимостью выше средней по принтерам
--
select model  from printer p 
where price > (select avg(price) from printer p)

-- Задание 16: Какое количество уникальных продуктов среди PC и Laptop
--
select(
(select count(distinct(model))
from pc p )
+
(select count(distinct(model))
from laptop l ))

-- Задание 17: Какая средняя цена среди уникальных продуктов производителя = 'A' (только printer & laptop, без pc)
--
-- Задание 17: Какая средняя цена среди продуктов производителя = 'A' (только printer & laptop, без pc)

/*
*/

select * from (
select model, price from printer p 
union 
select model, price from laptop l
)
join 





-- Задание 18: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D'. Вывести model
--

select p.model from product p 
join
printer pr
on p.model =pr.model 
where maker = 'A'
and price> 
(
	select avg(price) from product p 
	join
	printer pr
	on p.model =pr.model 
	where maker = 'D'
)

-- Задание 19: Найдите производителей, которые производили бы как PC со скоростью (speed) не менее 750, так и laptop со скоростью (speed) не менее 750. Вывести maker
--

select distinct(maker)
from(
	select maker from product
	join
	pc
	on product.model =pc.model 
	where pc.speed >=750
	union 
	select maker from product
	join
	laptop
	on product.model =laptop.model 
	where laptop.speed >=750
) u 

-- Задание 20: Найдите средний размер hd PC каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.

select maker, avg(hd) 
from pc p
join product p2 
on p.model = p2.model
where maker in 
(select distinct maker from printer p
join product p2 
on p.model = p2.model)
group by maker




--select * from product p 


