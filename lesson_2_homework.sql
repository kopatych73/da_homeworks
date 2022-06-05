--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

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

-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
--
select name, class from ships
where launched > 1920
 
-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
--
select name, class from ships
where launched between 1920 and 1942
 
-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
--
 
select class, count(class)
from ships 
group by class 
 
-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
--
 
select class, country  from classes
where bore >=16
 
-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
--
select ship from outcomes o 
where result = 'sunk'
and battle = 'North Atlantic' 
 

-- Задание 6: Вывести название (ship) последнего потопленного корабля
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

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
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

-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
--
select o.ship , c."class"  
from outcomes o 
join ships s
on s."name" = o.ship 
join classes c
on c."class"  = s."class" 
where "result" = 'sunk'
and bore >=16

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
--
select class from classes c 
where country = 'USA'

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class

select name, classes.class from ships s 
join classes 
on classes."class"  = s."class" 
where country = 'USA'
