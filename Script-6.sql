--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson5)
-- ������������ �����: ������� ������ ����� ������� ��������� �� ������� ���� (type)

select * from (
select *,
row_number() over (partition by "type" order by price) as rn 
from printer p 
) rnf
where rn = 1

--task2  (lesson5)
-- ������������ �����: ������� ������ ����� ������� PC �� ������� ���� ��������

select * from (
				select *,
				row_number() over (partition by speed order by price) as rn
				from pc p 
			) r
where rn = 1

--task3  (lesson5)
-- ������������ �����: ����� ��������������, ������� ���������� ����� 2-� ������� PC (����� RANK, �� having).


select distinct maker from product p2 
join 
(select * from (
select model, count(rnk) from (
	select *,
	rank() over (order by model) rnk
	from pc p 
) a
group by model
) b
where count >1) c
on p2.model  = c.model

-- teacher version 

select distinct maker 
from (
  select *,
  rank() over (partition by maker order by model)
  from product 
  where type = 'PC'
) a 
where rank > 2


--task4 (lesson5)
-- ������������ �����: ������� ������ ����� ������� PC �� ������� �������������. �����: maker, code, price

select maker, code, price from(
with uni as (
select * from pc p 
join product p2 
on p.model =p2.model)
select *,
row_number() over (partition by maker order by price) rn
from uni
) aa
where rn = 1


--teacher version 

select maker, code, price 
from ( 
 select*, 
 rank () over (partition by maker order by price)  
 from  product  
 join pc  
 on product.model = pc.model 
 where type = 'PC' 
 ) a 
 where rank = 1

--task5 (lesson5)
-- ������������ �����: ������� view (all_products_050521), � ������ �������� ����� ������ 2 ����� ������� ������� �� ������� �������������

drop view all_products_050521

create view all_products_050521 as
select maker, type, price
from 
(
	select a.model, a.price, rn
	row_number() over (partition by maker order by price desc) rn
	from product p 
	join (
		select model, price  
		  from pc 
		    union all   
		  select model, price  
		  from laptop  
		    union all 
		  select model, price  
		  from printer 
		) a 
	on a.model = p.model 
) b 
where rn <=2

select * from all_products_050521


-- teacher

create view all_products_050521 as  
 
select * 
from 
 ( 
 select *, 
 row_number() over (partition by maker order by price DESC) as rn 
 from 
  ( 
  select product.model, maker, price, product.type 
   from product 
   join laptop 
   on product.model = laptop.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join pc 
    on product.model = pc.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join printer 
    on product.model = printer.model 
    ) as foo 
 ) as foo1 
where rn >=1 and rn <=2 ; 
 
select * 
from all_products_050521


--task6 (lesson5)
-- ������������ �����: ������� ������ �� ������� ����� �� ���� ������� �� ������� ������������� (X: maker, Y: avg_price) �� ���� view all_products_050521

select *,
avg(price) over (partition by maker)
from all_products_050521

select maker, avg(price) avg
from all_products_050521
group by maker


--task7 (lesson5)
-- ������������ �����: ��� ������� �������� �� ������� printer ����� �������� ����� ��� ����� � ����������� ����� �� ������ � ����� �� ��������� ���� (type, � �����)

--task8 (lesson5)
-- ������������ �����: ��� ������� �������� �� ������� printer ����� �������� ����� ��� ����� � ����������� ����� �� ������ � ����� �� ��������� color (type, � �����)

select *,
price - min(price) over (partition by color) as rn
from printer p 

--task9 (lesson5)
-- ������������ �����: ��� ������� maker  �� ������� product ������� ��� ����� ������� ���������� (����� ������� �������).

select * 
from 
 ( 
 select *, 
 row_number() over (partition by maker order by price DESC) as rn 
 from 
  ( 
  select product.model, maker, price, product.type 
   from product 
   join laptop 
   on product.model = laptop.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join pc 
    on product.model = pc.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join printer 
    on product.model = printer.model 
    ) as foo 
 ) as foo1 
where rn >=1 and rn <=3 ; 


--task10 (lesson5)
-- ������������ �����: ��� ������� ������������� ������� �� ��� ����� ������� ���������� � ��������� view (products_with_lowest_price).

create view products_with_lowest_price as
select * 
from 
 ( 
 select *, 
 row_number() over (partition by maker order by price) as rn 
 from 
  ( 
  select product.model, maker, price, product.type 
   from product 
   join laptop 
   on product.model = laptop.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join pc 
    on product.model = pc.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join printer 
    on product.model = printer.model 
    ) as foo 
 ) as foo1 
where rn >=1 and rn <=3 ; 

select * from products_with_lowest_price


--task11 (lesson5)
-- ������������ �����: ��������� ������ � �� ������� � ������������ ������ �� ���� products_with_lowest_price (X: maker, Y1: max_price, Y2: avg)price


