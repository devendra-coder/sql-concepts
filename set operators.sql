-- set operators

-- union operator(removes duplicates)
use SalesDB
select 
FirstName as Name,
LastName as Surname
from Sales.Customers
union
select
FirstName,
LastName
from Sales.Employees


-- union all(includes the duplicates)
select 
FirstName as Name,
LastName as Surname
from Sales.Customers
union all
select
FirstName,
LastName
from Sales.Employees


-- except operator/minus operator(return unique rows in the first table that are not in the second table)
/* find employees who are not customers at the same time */
select 
FirstName as Name,
LastName as Surname
from Sales.Employees
except
select
FirstName,
LastName
from Sales.Customers


-- intersect operator
/* find the employees who are also the customers */
select 
FirstName as Name,
LastName as Surname
from Sales.Employees
intersect
select
FirstName,
LastName
from Sales.Customers


-- orders data are stored in separte tables (orders and ordersarchive)
-- Combine all orders data into one report without duplicates
SELECT 'Orders' as Source
      ,[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
  FROM Sales.Orders
union
SELECT 'OrdersArchive' as Source
      ,[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
  FROM Sales.OrdersArchive
  order by OrderID
