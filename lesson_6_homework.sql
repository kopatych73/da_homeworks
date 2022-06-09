--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model

with allprod as
(
select code, model, price
 from laptop l 
  union all
 select code, model, price
 from pc  
  union all
 select code, model, price
 from printer)

select model from allprod ap where price = (select max(price) from allprod)


--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all) 
-- и сделать флаг (flag) по цене > максимальной по принтеру. 
-- Также добавить нумерацию (через оконные функции) по каждой категории продукта в порядке возрастания цены (price_index). По этому price_index сделать индекс

create table all_products_with_index_task5 as

with allprod as
(
select code, model, price
 from laptop l 
  union all
 select code, model, price
 from pc  
  union all
 select code, model, price
 from printer)
select code, p.model, price, maker, type, 
case
	when price > (select max(price) from printer p) then 1
	else 0
end flag,
row_number() over (partition by type order by price) price_index
from allprod ap
 join product p 
 on p.model  = ap.model
 
create index price_idx on all_products_with_index_task5 (price_index);

select * from all_products_with_index_task5 apwit 

 