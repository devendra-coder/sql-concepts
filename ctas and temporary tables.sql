-- ctas(create table as select)
-- permanent tables
-- show total number of orders of each month
select 
	datename(month,OrderDate) as OrderMonth,
	count(OrderID) as TotalOrders
into Sales.MonthlyOrders
from Sales.Orders
group by datename(month,OrderDate)


-- create a ctas that refreashes itself from the data base
-- in this we use t sql
if object_id('Sales.MonthlyOrders','U') is not null /* here U stands for user defined */
	drop table Sales.MonthlyOrders
go
select 
	datename(month,OrderDate) as OrderMonth,
	count(OrderID) as TotalOrders
into Sales.MonthlyOrders
from Sales.Orders
group by datename(month,OrderDate)


-- temporary tables
-- #tables_name is used to create a temporary table
select 
*
into #Orders
from Sales.Orders

select 
*
from #Orders

