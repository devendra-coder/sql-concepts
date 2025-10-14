-- rank window functions

-- row_number function
-- rank the orders based on their sales from highest to lowest
select
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() over(order by sales desc) salesRank
from Sales.Orders

-- rank function
-- rank the orders based on their sales from highest to lowest using rank function
select
	OrderID,
	ProductID,
	Sales,
	rank() over(order by sales desc) salesRank
from Sales.Orders;

-- dense rank function
-- rank the orders based on their sales from highest to lowest using dense rank function
select
	OrderID,
	ProductID,
	Sales,
	dense_rank() over(order by sales desc) salesRank
from Sales.Orders;

-- find the top highest sales for each product
select
*
from(
select
OrderID,
ProductID,
Sales,
RANK() over(partition by ProductID order by Sales desc) as RankByProductSales
from sales.Orders
)t where RankByProductSales =1


-- find the lowest two customers based on their total sales
select
*
from(
select
CustomerID,
sum(Sales) as TotalSales,
rank() over(order by sum(Sales)) as RankCustomers
from Sales.Orders
group by CustomerID
)t where RankCustomers <=2

-- assign unique IDs to the row s of the orders archive table
select
ROW_NUMBER() over(order by OrderID, OrderDate) UniqueID,
*
from Sales.OrdersArchive

-- identify duplicate rows in the table orders archive
-- and return a clean result without any duplicates
select 
*
from(
select 
row_number() over(partition by OrderID order by CreationTime desc) rn,
*
from Sales.OrdersArchive
)t where rn = 1

-- ntile(Number of Buckets) function
-- Bucket size = number of rows / number of buckets
select
OrderID,
Sales,
NTILE(1) over(order by Sales desc) OneBucket,
NTILE(2) over(order by Sales desc) TwoBucket,
NTILE(3) over(order by Sales desc) ThreeBucket
from Sales.Orders

-- segment all orders into 3 categories: high medium and low sales
select
*,
case when Buckets=1 then 'High'
	 when Buckets=2 then 'Medium'
	 when Buckets=3 then 'Low'
end SalesSegmentation
from(
select
OrderID,
Sales,
ntile(3) over(order by sales desc) Buckets
from Sales.Orders
)t

-- cume_dist function(position number / number of rows)
-- percent_rank function(position number - 1 / number of rows -1)
-- find the products that fall within the highest 40% of the prices
select
*,
concat(DistRank * 100,'%') DiscRankPercent
from(
select
Product,
Price,
CUME_DIST() over(order by Price desc) DistRank,
percent_rank() over(order by Price desc) PercentRank
from Sales.Products)t
where DistRank <= 0.4