select count(model), type
from product
where maker != 'E'
group by type 

--pc: макс значение цены по PC, сгруппированное по cd и без cd равно '12x'
--pc: макс значение цены по PC, сгруппированное по cd и без cd равно '12x' от большего к меньшему
select max(price) as max_price, cd 
from pc p
where cd != '12x'
group by cd 
order by max_price desc 

select * from product

insert into Product 
values('B','product_by_student_8','Laptop')

update Product
set maker = 'B_updated'
where model = 'product_by_student_8'

delete from product 
where model = 'product_by_student_8'