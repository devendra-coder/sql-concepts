-- views
-- find the running total for each month
/*create view V_Monthly_Summary as 
(
select 
DATETRUNC(MONTH,OrderDate) OrderMonth,
sum(sales) as TotalSales,
count(OrderID) as TotalOrders,
sum(Quantity) totalQuantities
from Sales.Orders
group by DATETRUNC(MONTH,OrderDate)
)*/

select 
OrderMonth,
TotalSales,
sum(TotalSales) over(order by OrderMonth) RunningTotal
from V_Monthly_Summary