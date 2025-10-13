-- NULL Functions
-- isnull function
-- coalesce function
select 
CustomerID,
Score,
coalesce(Score,0) as Score2,
avg(Score) over() avg_score,
avg(coalesce(Score,0)) over() avg_score2
from Sales.Customers

-- display the full name of customers in a single field 
-- by merging their first and last names
-- and add 10 bonus points to each customer's score
select 
CustomerID,
FirstName,
LastName,
coalesce(FirstName,'')+' '+coalesce(LastName,'') as FullName,
Score,
coalesce(Score,0)+10 as ScoreWithBonus
from Sales.Customers

-- sort the customers from lowest to highest scores
-- with null appearing last
select
CustomerID,
Score,
case when Score is null then 1 else 0 end Flag
from Sales.Customers
order by case when Score is null then 1 else 0 end,Score

-- find the sales price for each order by dividing sales by quantity
-- nullif function
select
OrderID,
Sales,
Quantity,
Sales/nullif(Quantity,0) as Price
from Sales.Orders