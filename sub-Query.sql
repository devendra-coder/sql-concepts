-- sub-query

-- result type sub-query
-- scalar query
select
avg(Sales) AvgSales
from Sales.Orders

-- row query
select
CustomerID
from Sales.Orders

-- table query
select
*
from Sales.Orders


-- location/clause sub-query
-- from clause subquery
/*Find the product that have a price higher than the
average price of all products*/
select
*
from(
select 
ProductID,
Price,
avg(price) over() avgPrice
from Sales.Products
)t where Price > avgPrice

-- rank customers based on their total amount of sales
select 
*,
rank() over(order by TotalSales desc) CustomerRank
from(
select 
CustomerID,
sum(Sales) TotalSales
from Sales.Orders
group by CustomerID
)t

-- select clause subquery
-- show the product IDs, products names, prices, and the total number of orders
select
ProductID,
Product,
Price,
(Select count(*)
from Sales.Orders) as TotalOrders
from Sales.Products

-- join clause subquery
-- show all customer details and find the total orders of each customer
select c.*,
o.TotalOrders
from Sales.Customers as c
left join(
select 
CustomerID,
count(*) as TotalOrders
from Sales.Orders
group by CustomerID) o
on c.CustomerID = o.CustomerID

-- where clause subquery
-- using comparison operator
/*Find the product that have a price higher than the
average price of all products*/
select
ProductID,
Price
from Sales.Products
where Price > (select avg(Price) from Sales.Products)

-- logical operators
-- in operator
-- show the details of orders made by customers in Germany
select *
from Sales.Orders
where CustomerID in 
            (select
			CustomerID
			from Sales.Customers
			where Country = 'Germany')

-- any operator
-- find female employees whose salaries are greater
-- than the salaries of any male employees
select 
EmployeeID,
FirstName,
Salary
from Sales.Employees
where Gender = 'F'
and Salary > any
(select 
Salary
from Sales.Employees
where Gender = 'M')

-- all operator
-- find female employees whose salaries are greater
-- than the salaries of all male employees
select 
EmployeeID,
FirstName,
Salary
from Sales.Employees
where Gender = 'F'
and Salary > all
(select 
Salary
from Sales.Employees
where Gender = 'M')

-- correlated Subquery
-- show all customer details and find the total orders of each customers
select
*,
(select count(*) from Sales.Orders o where o.CustomerID = c.CustomerID) as TotalSales
from Sales.Customers as c

-- exists operator
-- show the details of orders made by customers in Germany
select 
*
from Sales.Orders o
where exists (select 1
				from Sales.Customers c
				where Country = 'Germany'
				and o.CustomerID = c.CustomerID)