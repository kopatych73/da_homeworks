--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson4)
-- Корабли: Вывести список кораблей, у которых начинается с буквы "S"

select * from ships s  where "name"  like 'S%'

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название: pc_with_flag_speed_price) над таблицей PC c флагом: flag = 1 для тех, у кого speed > 500 и price < 900, для остальных flag = 0

create view pc_with_flag_speed_price as
select *, 
case 
	when (speed > 500 and price < 900 ) then 1 
else 0
end flag
from pc p 

select * from pc_with_flag_speed_price

--task3  (lesson4)
-- Компьютерная фирма: Сделать view (название: pc_maker_a) со всеми товарами производителя A. В view должны быть следующие колонки: model, price

create view pc_maker_a as
select p.model, price from product p 
join (select model, price from pc
union all
select model, price from laptop
union all
select model, price from printer
) uni
on uni.model = p.model 
where maker = 'A'


create view pc_maker_a as 
 
with all_products as ( 
  select model, price  
  from pc 
    union all   
  select model, price  
  from laptop  
    union all 
  select model, price  
  from printer 
) 
select price, all_products.model  
from all_products 
join product  
on all_products.model=product.model  
where maker = 'A' ;

--task4 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы laptop (название: laptop_under_1000) и удалить из нее все товары с ценой выше 1000.

create table laptop_under_1000 as
select * from laptop l;
delete from laptop laptop_under_1000
where price > 1000;
select * from laptop_under_1000

--task5 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы (название: all_products) со средней стоимостью всех продуктов, с максимальной ценой и количеством по каждому производителю. (дубликаты можно учитывать).

create view all_prod as
 select model, price  
  from pc 
    union all   
  select model, price  
  from laptop  
    union all 
  select model, price  
  from printer 

create table all_products as
select maker, avg(price), max(price), count(product.model)
from all_prod 
join product  
on all_prod.model=product.model  
group by maker

select * from all_products ap 

--task6 (lesson4)
-- Компьютерная фирма: Построить по all_products график в colab/jupyter (X: maker, Y: средняя цена)


#join по таблицам laptop & product
request = """
select maker, avg 
from all_products
order by maker
"""
df = pd.read_sql_query(request, conn)
#fig = px.bar(x=df.maker.to_list(), y=df['count'].to_list(), labels={'x':'maker', 'y':'avg price'}) - count
fig = px.bar(x=df.maker.to_list(), y=df.avg.to_list(), labels={'x':'maker', 'y':'avg price'})
fig.show()


--task7 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы (название: all_products) со средней стоимостью всех продуктов, с максимальной ценой продукта и количеством продуктов по каждому производителю. (дубликаты можно учитывать).

--task8 (lesson4)
-- Компьютерная фирма: Сделать view (название products_price_categories), в котором по всем продуктам нужно посчитать количество продуктов всего в зависимости от цены:
-- Если цена > 1000, то category_price = 2
-- Если цена < 1000 и цена > 500, то  category_price = 1
-- иначе category_price = 0
-- Вывести: category_price, count

create view products_price_categories as
select category_price, count(category_price) from
(
select *,
case 
	when price > 1000 then 2
	when price <1000 and price > 500 then 1
	else 0
end category_price
from all_prod ap 
) a
group by category_price

select * from products_price_categories ppc 



-- решение тренера:

create view products_price_categories as 
with all_products as ( 
 select price, model 
 from laptop l  
  union all 
 select price, model 
 from pc   
  union all 
 select price, model 
 from printer 
) 
select count(*), 
case when price&gt;1000 then 2 
when price &lt;100 and price &gt;500 then 1 
else 0 
end category_price 
from all_products  
join product p
on p.model=all_products.model
group by category_price

--task9 (lesson4)
-- Сделать предыдущее задание, но дополнительно разбить еще по производителям (название products_price_categories_with_makers). Вывести: category_price, count, price

select maker, price from all_prod ap 
join product p 
on ap.model =p.model 

--task10 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по каждому производителю график (X: category_price, Y: count)

--task11 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по A & D график (X: category_price, Y: count)

--task12 (lesson4)
-- Корабли: Сделать копию таблицы ships, но у название корабля не должно начинаться с буквы N (ships_without_n)
