-- date and time funtions
-- getdate function
use SalesDB
select
OrderID,
CreationTime,
getdate() as Today
from Sales.Orders

-- part extration functions

-- day function
-- month function
-- year function
select
OrderID,
CreationTime,
year(CreationTime) as Year,
month(CreationTime) as Month,
day(CreationTime) as day
from Sales.Orders

-- datepart function
select
OrderID,
CreationTime,
datepart(year, CreationTime) as Year_dp,
datepart(month, CreationTime) as Month_dp,
datepart(day, CreationTime) as Day_dp,
datepart(hour, CreationTime) as hour_dp,
datepart(QUARTER, CreationTime) as Quater_dp,
datepart(WEEKDAY, CreationTime) as weekday_dp,
datepart(week, CreationTime) as week_dp
from Sales.Orders

-- datename function
select
OrderID,
CreationTime,
datename(month, CreationTime) as Month_dn,
datename(weekday, CreationTime) as Day_dn
from Sales.Orders

-- datetrunc function
select
OrderID,
CreationTime,
DATETRUNC(MINUTE,CreationTime) as Min_dt,
DATETRUNC(day,CreationTime) as Day_dt,
DATETRUNC(Year,CreationTime) as Year_dt
from Sales.Orders

select
DATETRUNC(month, CreationTime) as Creation,
count(*) as orders
from Sales.Orders
group by DATETRUNC(month, CreationTime)

-- how many orders were placed each year?
select
Year(OrderDate) as year,
count(*) as number_of_orders
from Sales.Orders
group by year(OrderDate) 

-- how many orders were placed each month?
select
datename(month,OrderDate) as month,
count(*) as number_of_orders
from Sales.Orders
group by datename(month,OrderDate) 

-- show all the orders that were placed during the month of february
select *
from Sales.Orders
where month(OrderDate) = 2


-- Format and casting functions
-- format function

select 
OrderID,
CreationTime,
format(CreationTime,'dd') as dd,
format(CreationTime,'ddd') as ddd,
format(CreationTime,'dddd') as dddd,
format(CreationTime,'MM') as MM,
format(CreationTime,'MMM') as MMM,
format(CreationTime,'MMMM') as MMMM
from Sales.Orders

-- convert function
select
convert(int, '123') as string_to_int,
convert(date, '2025-08-16') as string_to_date,
CreationTime,
convert(date, CreationTime) as datetime_to_date
from Sales.Orders

-- cast function
select
cast('23' as int) as string_to_int,
cast(123 as varchar) as int_to_varchar,
CreationTime,
cast(CreationTime as Date) as datetime_to_date
from Sales.Orders


-- calculations functions
-- dateadd function
select 
OrderID,
OrderDate,
dateadd(year,2,OrderDate) as twoyearslater,
dateadd(month,10,OrderDate) as tenmonthslater,
dateadd(day,-10,OrderDate) as tendaysbefore
from Sales.Orders

-- datediff function
-- find the average shipping duration in days for each month 
select
datename(month,OrderDate) as month,
avg(DATEDIFF(day,OrderDate,ShipDate)) as avg_shipping_duration
from Sales.Orders
group by datename(month,OrderDate)
order by avg_shipping_duration desc

--calculate the age of employee
select
EmployeeID,
BirthDate,
DATEDIFF(year,BirthDate,GETDATE()) as age
from Sales.Employees


-- date validation function
-- isdate function
select 
isdate('123') as checkdate1,
isdate('2025-08-21') as checkdate1