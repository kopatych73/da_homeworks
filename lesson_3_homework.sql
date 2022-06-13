--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, 
--потопленных в сражениях. Вывести: класс и число потопленных кораблей.

select class, count(ship) from ships s 
join 
	outcomes o 
on s."name" =o.ship 
	where o."result" = 'sunk'
	group by "class" 


--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

select c."class" , l from classes c
join 
	(select class, min(launched) l from ships s 
	group by "class") ml
on  ml.class = c."class" 

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

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
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий 
--среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

with max_numgun as (
  select displacement, max(numguns ) from classes c
  group by displacement),
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
--Компьютерная фирма: Найдите производителей принтеров, 
--которые производят ПК с наименьшим объемом RAM и 
--с самым быстрым процессором среди всех ПК, имеющих 
--наименьший объем RAM. Вывести: Maker

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
