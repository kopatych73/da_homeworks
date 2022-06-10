-- ������� 9: ��������� ���������� ��������� ����� cd � ������� PC

select count(distinct cd) from pc

-- ������� 10: ����� ���������� ��������� � ������� ������������� (maker), ��������� (price) ������� (��������) ������ 280

select maker, count(*)   from product p 
join
printer p2 
on p.model = p2.model 
where price > 280
group by maker 

-- ������� 11: ����� ������ ��������� � ����� ������� �����. �������: model, price

select model, price from printer p
where price = (select max(price) from printer p) 

--
-- ������� 12: ������� ������� � ������� ���� ����� PC � ���������� (Printer)
--
select ((select avg(price) from printer) - (select avg(price) from pc)) as diff

-- ������� 13: ������� �������������� ����� ������� ���������. ������� price, maker
--
select maker,price from product p
join
printer p2
on p.model = p2.model 
where price = (select min(price) from printer p)

-- ������� 14: ������� �������������� ����� ������� ������� ��������� (color = 'y')
--
select maker 
from product 
join printer 
on product.model = printer.model 
where price = (select min(price) from  printer where color = 'y' ) 
and color = 'y'

-- ������� 15: ������� ��� �������� �� ���������� ���� ������� �� ���������
--
select model  from printer p 
where price > (select avg(price) from printer p)

-- ������� 16: ����� ���������� ���������� ��������� ����� PC � Laptop
--
select(
(select count(distinct(model))
from pc p )
+
(select count(distinct(model))
from laptop l ))

-- ������� 17: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (������ printer & laptop, ��� pc)
--
-- ������� 17: ����� ������� ���� ����� ��������� ������������� = 'A' (������ printer & laptop, ��� pc)

/*
*/

select * from (
select model, price from printer p 
union 
select model, price from laptop l
)
join 





-- ������� 18: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D'. ������� model
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

-- ������� 19: ������� ��������������, ������� ����������� �� ��� PC �� ��������� (speed) �� ����� 750, ��� � laptop �� ��������� (speed) �� ����� 750. ������� maker
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

-- ������� 20: ������� ������� ������ hd PC ������� �� ��� ��������������, ������� ��������� � ��������. �������: maker, ������� ������ HD.

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


