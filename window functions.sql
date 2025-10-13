-- window functions
--  find total salse across all orders
use SalesDB

select
sum(Sales) as TotalSalse
from Sales.Orders

-- find total sales for each product
select 
ProductID,
sum(Sales) as TotalSales
from Sales.Orders
group by ProductID


/* find the total sales across all orders 
additionally provide details such as order id, order date */
select 
OrderID,
OrderDate,
sum(Sales) over() as TotalSales
from Sales.Orders


/* find the total sales for each product 
additionally provide details such as order id, order date */
select 
OrderID,
OrderDate,
ProductID,
sum(Sales) over(partition by ProductID) as TotalSalesByProducts
from Sales.Orders

/* find the total sales for each combination of products and order status */
select 
OrderID,
OrderDate,
ProductID,
OrderStatus,
Sales,
sum(sales) over() as totalSalse,
sum(Sales) over(partition by ProductID) as SalesByProducts,
sum(Sales) over(partition by ProductID,OrderStatus) as SalesByProductsAndStatus
from Sales.Orders


-- frame clause
-- by using order by a default frame is attched to it(rows between unbounded preceding and current row )
select 
OrderID,
OrderDate,
OrderStatus,
Sales,
sum(Sales) over(partition by OrderStatus order by OrderDate 
rows between current row and 2 following) as TotalSales
from Sales.Orders
