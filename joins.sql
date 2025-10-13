use MyDatabase
select * 
from customers
-- retrieve all order data
select *
from orders


select * from customers
where not score < 500

select * from customers
where score between 100 and 500

select * from customers
where country in ('Germany','USA')


select * from customers
where first_name like '__r%'

select * from customers
select * from orders

-- inner join
/* get all customers along with their orders, but only for constomers who have placeed an order*/
select 
	id,
	first_name,
	order_id,
	sales
from customers 
inner join orders
on customers.id = orders.customer_id

-- left join
/* get all customers along with their orders including those without orders*/
select 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from customers as c
left join orders as o 
on c.id = o.customer_id

-- right join
/* get all customers along with their orders including orders without matching customers*/
select 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from customers as c
right join orders as o 
on c.id = o.customer_id

-- left-anti join
/* get all customers who have not placed any order */
select *
from customers as c
left join orders as o 
on c.id = o.customer_id
where o.customer_id is null

-- right-anti join
/* get all orders without matching customers */
select *
from customers as c
right join orders as o 
on c.id = o.customer_id
where c.id is null

-- full-anti join
/* find customers without orders and orders without customers */
select *
from customers as c
full join orders as o
on c.id = o.customer_id
where c.id is null or o.customer_id is null

/* get all customers along with their orders but only for customers who have placed an order (without using inner join) */
select *
from customers as c
full join orders as o
on c.id = o.customer_id
where not c.id is null and not o.customer_id is null

-- cross join
/* generate all possible combination of customers and orders */
select * 
from customers
cross join orders


use SalesDB

/* tast: using SalesDB retrieve a list of all orders along with the related customer, products,
and employee details. For each order, display:
Order ID, Customer's name, Product name, Sales, Price, Sales person's name */
select 
	o.OrderID,
	o.Sales,
	c.FirstName,
	c.LastName,
	p.Product as Product_Name,
	p.price,
	e.FirstName as Employee_FirstName,
	e.LastName as Employee_LastName
from Sales.Orders as o
left join Sales.Customers as c
on o.CustomerID=c.CustomerID
left join Sales.Products as p
on o.ProductID = p.ProductID
left join Sales.Employees as e
on o.SalesPersonID = e.EmployeeID