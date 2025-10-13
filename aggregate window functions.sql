-- aggregate window functions

-- count function
-- find  total number of orders
select
OrderID,
OrderDate,
count(*) over()
totalOrders
from Sales.Orders

-- sum function
-- find the total sales across all orders
-- and the total sales for each product
-- additionally provide details such as order id, order date
use SalesDB
select
orderID,
OrderDate,
ProductID,
Sales,
sum(Sales) over() as OverallSales,
sum(Sales) over(partition by ProductID) as SalesByProduct
from Sales.Orders

-- average(avg) function
-- find the avgrage sales across all orders
-- and the average sales for each product
-- additionally provide details such as order id, order date
use SalesDB
select
orderID,
OrderDate,
ProductID,
Sales,
avg(Sales) over() as AvgSales,
avg(Sales) over(partition by ProductID) as AVGSalesByProduct
from Sales.Orders

-- find all customers where score is higher than the average score across all customers 
select
*
from(
select 
CustomerID,
Score,
avg(Score) over() as avgScore
from Sales.Customers
)t where Score > avgScore


-- calcutate moving average and rolling average of sales for each product over time(running average)
select
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	avg(Sales) over(partition by ProductID) AvgByProduct,
	avg(sales) over(partition by ProductID order by OrderDate) MovingAvg,
	avg(sales) over(partition by ProductID order by OrderDate rows between 1 preceding and current row) RollingAvg
from Sales.Orders