-- homework 26/05/2022

select * from ships


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

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
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



-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
--

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
--

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class