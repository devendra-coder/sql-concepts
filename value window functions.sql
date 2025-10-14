use SalesDB
-- value window functions

-- lean and lag function
-- analyze the month-over-month(MoM) performance
-- by finding the percentage change in sales
-- between the current and previous month
select
*,
CurrentMonthSales-PreviousMonthSales as MoM_Change,
round(cast((CurrentMonthSales-PreviousMonthSales) as float)/PreviousMonthSales*100,1) as MoM_percentage
from(
select
month(OrderDate) OrderMonth,
sum(Sales) CurrentMonthSales,
lag(sum(Sales)) over(order by month(OrderDate)) PreviousMonthSales
from Sales.Orders
group by month(OrderDate)
)t

-- in order to analyze cutomer loyalty
-- rank customers based on the average days between their orders
select
CustomerID,
avg(DaysUntilNextOrder) AvgDays,
rank() over(order by coalesce(avg(DaysUntilNextOrder),999999)) Rank
from(
select
OrderID,
CustomerID,
OrderDate as CurrentOrder,
lead(OrderDate) over(partition by CustomerID order by OrderDate) NextOrder ,
DATEDIFF(day,OrderDate,lead(OrderDate) over(partition by CustomerID order by OrderDate)) DaysUntilNextOrder
from Sales.Orders
)t
group by CustomerID


-- first_value and last_value function
-- find the lowest and highest sales for each product
select 
OrderID,
ProductID,
Sales,
FIRST_VALUE(Sales) over(partition by ProductID order by Sales) LowestVal,
LAST_VALUE(Sales) over(partition by ProductID order by Sales rows between current row and unbounded following) highestVal,
FIRST_VALUE(Sales) over(partition by ProductID order by Sales desc) HighestVal2
from Sales.Orders
