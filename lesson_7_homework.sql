--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

import sqlite3
conn = sqlite3.connect('task1_7.db')  #('TestDB.db')  
c = conn.cursor()
-----------------------------------
import pandas as pd
import plotly.graph_objs as go
-----------------------------------
request = """CREATE TABLE table1 (
            x int,
            y int,
            z int)	
           """
c.execute(request)
tables = c.fetchall()
-----------------------------------
request = """ 
with recursive generate_series(r1,r2,r3) as (
    select abs(random() % 1000) as r1, abs(random() % 1000) as r2, abs(random() % 1000) as r3
    union all select abs(random() % 1000) as r1, abs(random() % 1000) as r2, abs(random() % 1000) as r3
    from generate_series
    limit 1000)
select * from generate_series;
""" 
df = pd.read_sql_query(request, conn)
df.to_sql('table1', conn)
-----------------------------------
req = 'select * from table1'
c.execute(req)
table = c.fetchall()
-----------------------------------
df = pd.read_sql_query('SELECT * from table1', conn)
-----------------------------------
fig = go.Figure()
fig.add_trace(go.Histogram(x=df['r1']))
fig.add_trace(go.Histogram(x=df['r2']))
fig.add_trace(go.Histogram(x=df['r3']))
fig.show()
-----------------------------------


--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

/* Write your PL/SQL query statement below */
select distinct email from (
select email,
row_number() over (partition by email order by email) as pt
from person
)
where pt >1

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

select e1.name as Employee from Employee  e1
join Employee e2
on e1.managerid=e2.id
where e1.salary>e2.salary


--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

select score,
dense_rank() over (order by score DESC) AS RANK
FROM Scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select firstname, lastname, city, state from person
left join address
on person.personid = address.personid
