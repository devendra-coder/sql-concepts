/* create report showing total sales for each of the following categories:
high(sales over 50), medium(sales 21-50) and low(sales 20 or less)
sort the categories from highest sales to lowest */
select
Category,
sum(Sales) as TotalSales
from(
	select 
	OrderID,
	Sales,
	Case
		when Sales>50 then 'High'
		when Sales>20 then 'Medium'
		else 'Low'
	end Category
	from Sales.Orders
)t
group by Category
order by TotalSales desc


-- count how many times each customer has made an order with sales greater than 30
select
CustomerID,
sum(case
	when sales>30 then 1
	else 0
end) totalOrders
from Sales.Orders
group by CustomerID
order by CustomerID

select * from Sales.Orders