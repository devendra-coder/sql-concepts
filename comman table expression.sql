-- standalone cte
-- step 1: find the total sales per customer
with cte_total_Sales as
(
select
	CustomerID,
	sum(Sales) as totalSales
from Sales.Orders
group by CustomerID
)
-- step 2: find the last order date for each customer
,cte_last_order as
(
select 
CustomerID,
max(OrderDate) as last_order
from Sales.Orders
group by CustomerID
)
-- nested CTE
-- step 3: rank customers based on total sales per customers
,cte_customer_rank as
(
select
CustomerID,
totalSales,
rank() over(order by totalSales desc) as CustomerRank
from cte_total_Sales
)
-- step 4: segment customers based on their total sales
,cte_customer_segment as
(
select
CustomerID,
case when totalSales > 100 then 'High'
	 when totalSales > 80 then 'Medium'
	 else 'Low'
end CustomerSegments
from cte_total_Sales
)
-- main query
select 
c.CustomerID,
c.FirstName,
c.LastName,
cts.totalSales,
clo.last_order,
ccr.CustomerRank,
ccs.CustomerSegments
from Sales.Customers c
left join cte_total_Sales cts
on cts.CustomerID = c.CustomerID
left join cte_last_order clo
on clo.CustomerID = c.CustomerID
left join cte_customer_rank as ccr
on ccr.CustomerID = c.CustomerID
left join cte_customer_segment ccs
on ccs.CustomerID = c.CustomerID


-- recursive cte
-- generate a sequence of numbers from 1 to 20
with Series as
(
	-- Anchor Query
	select
	1 as MyNumber
	union all
	-- recursive query
	select 
	MyNumber + 1
	from Series
	where MyNumber < 20
)
-- main query
select * 
from Series


-- show the employee hierarchy by displaying each employee's level within the organization
with CTE_Emp_Hierarchy as
(
-- anchor query
select 
	EmployeeID,
	FirstName,
	ManagerID,
	1 as Level
from Sales.Employees
where ManagerID is null
union all
-- recursive query
select 
	e.EmployeeID,
	e.FirstName,
	e.ManagerID,
	Level+1
from Sales.Employees as e
inner join CTE_Emp_Hierarchy ceh
on e.ManagerID = ceh.EmployeeID
)
-- main query
select
*
from CTE_Emp_Hierarchy