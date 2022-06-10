
--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing


--task1
--Компьютерная фирма: Найдите среднюю цену всех устройств, сгруппированую по производителям.
--Вывод: цена, производитель
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
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL).
select * from ships
where class is null 



--task3
--Компьютерная фирма: Найти поставщиков/производителей компьютеров, моделей которых нет в продаже (то есть модели этих поставщиков отсутствуют в таблице PC)


with model_pc as 
(
	select model from pc 
	
) 
select * from product
where model not in
(select model from model_pc)
and type = 'PC'

	
	-- корректный код:
with model_pc_exists as (
	select distinct model 
	from pc
)
select * --distinct maker 
from product 
where model not in (select model from model_pc_exists)
	


--task4
--Компьютерная фирма: Найти модели и цены портативных компьютеров, стоимость которых превышает стоимость любого ПК

select model, price from laptop where price > any (select price from pc)



--task5 +++
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model
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
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена больше 300 - "1", у остальных - "0"

select *,
case 
	when price>300 then 1
	else 0
end flag
from printer p 

--task7
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней - "1", у остальных - "0"
select *,
case 
	when price> (select avg(price) from printer) then 1
	else 0
end flag
from printer p 



--task9
--Компьютерная фирма: Вывести список всех уникальных PC и производителя с ценой выше хотя бы одного принтера. Вывод: model, maker

select distinct  product.model, maker from pc
join
product
on pc.model =product.model 
where price > any (select price from printer)

--task10
--Компьютерная фирма: Вывести список всех уникальных продуктов и производителя в рамках БД. Вывести model, maker

select distinct maker, model 
from product


--task11
--Корабли: Вывести список всех кораблей и класс. Для тех у кого нет класса - вывести 0, для остальных - class

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
--Корабли: Для каждого класса определить год, когда был спущен на воду первый корабль этого класса. Вывести: класс, год


--task13
--Компьютерная фирма: Вывести список всех продуктов и происзводителя с указанием типа продукта (pc, printer, laptpo). Вывести: model, maker, type

--task14
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"


select *,
case
	when price > (select avg(price) from pc) then 1
	else 0
end flag
 from printer p


--task15
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

--task16
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду. (через with)

--task17
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
 
select battle 
from outcomes o 
 join ships s 
on s.name = o.ship 
where class = 'Kongo'
 
 
