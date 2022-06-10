--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson4)
-- �������: ������� ������ ��������, � ������� ���������� � ����� "S"

select * from ships s  where "name"  like 'S%'

--task2  (lesson4)
-- ������������ �����: ������� view (��������: pc_with_flag_speed_price) ��� �������� PC c ������: flag = 1 ��� ���, � ���� speed > 500 � price < 900, ��� ��������� flag = 0

create view pc_with_flag_speed_price as
select *, 
case 
	when (speed > 500 and price < 900 ) then 1 
else 0
end flag
from pc p 

select * from pc_with_flag_speed_price

--task3  (lesson4)
-- ������������ �����: ������� view (��������: pc_maker_a) �� ����� �������� ������������� A. � view ������ ���� ��������� �������: model, price

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
-- ������������ �����: ������� ����� ������� laptop (��������: laptop_under_1000) � ������� �� ��� ��� ������ � ����� ���� 1000.

create table laptop_under_1000 as
select * from laptop l;
delete from laptop laptop_under_1000
where price > 1000;
select * from laptop_under_1000

--task5 (lesson4)
-- ������������ �����: ������� ����� ������� (��������: all_products) �� ������� ���������� ���� ���������, � ������������ ����� � ����������� �� ������� �������������. (��������� ����� ���������).

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
-- ������������ �����: ��������� �� all_products ������ � colab/jupyter (X: maker, Y: ������� ����)


#join �� �������� laptop & product
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
-- ������������ �����: ������� ����� ������� (��������: all_products) �� ������� ���������� ���� ���������, � ������������ ����� �������� � ����������� ��������� �� ������� �������������. (��������� ����� ���������).

--task8 (lesson4)
-- ������������ �����: ������� view (�������� products_price_categories), � ������� �� ���� ��������� ����� ��������� ���������� ��������� ����� � ����������� �� ����:
-- ���� ���� > 1000, �� category_price = 2
-- ���� ���� < 1000 � ���� > 500, ��  category_price = 1
-- ����� category_price = 0
-- �������: category_price, count

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



-- ������� �������:

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
-- ������� ���������� �������, �� ������������� ������� ��� �� �������������� (�������� products_price_categories_with_makers). �������: category_price, count, price

select maker, price from all_prod ap 
join product p 
on ap.model =p.model 

--task10 (lesson4)
-- ������������ �����: �� ���� products_price_categories_with_makers �� ������� �� ������� ������������� ������ (X: category_price, Y: count)

--task11 (lesson4)
-- ������������ �����: �� ���� products_price_categories_with_makers �� ������� �� A & D ������ (X: category_price, Y: count)

--task12 (lesson4)
-- �������: ������� ����� ������� ships, �� � �������� ������� �� ������ ���������� � ����� N (ships_without_n)
