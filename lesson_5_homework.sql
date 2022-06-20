--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). 
-- Вывод: все данные из laptop, номер страницы, список всех страниц

sample:
1 1
2 1
1 2
2 2
1 3
2 3

create view pages_all_products as
select *, 
	case 
		when mod(num,2) = 0 then num/2 
		else num/2 + 1 
	end as pagenumber, 
    case 
	    when mod(total,2) = 0 then total/2 
	    else total/2 + 1 
	end as allpages
from 
(
	select *, 
		row_number() over(order by model) as num, 
		(select count(*) from laptop) as total 
	from laptop
) foo;


select * from pages_all_products

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)

create view distribution_by_type as
select maker, type, max(rn) *100.0 /(select count(*) from product p) pp
from
(
select * 
		, (row_number() over (partition by maker, type)) rn
		--, (select count(*) from product)  cn
		--,count(*) over() total
	from product p 
) as foo
group by maker, type
order by maker

select * from distribution_by_type 

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/




--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов

create table ships_two_words
as (select substring(s."name", 1, 2) as name, class, launched from ships s )

select * from ships_two_words

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

select a.*, s2."class" from (
select s."name" from ships s 
union all
select ship from outcomes o 
) a
left join ships s2 
on a.name = s2."class" 
where class is null and a.name like 'S%'


--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model
