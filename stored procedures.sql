-- write a query 
-- for US Customers find the total number of cusotmers and the average score


select 
	count(*) totalCustomers,
	avg(score) avgScore
from Sales.Customers
where Country = 'USA'


-- turning the query into a stored procedure
create procedure GetCustomerSummary as
begin
select 
	count(*) totalCustomers,
	avg(score) avgScore
from Sales.Customers
where Country = 'USA'
end

-- execute the stored procedure
exec GetCustomerSummary


-- parametric stored procedure
alter procedure GetCustomerSummary @Country nvarchar(50) as
begin
select 
	count(*) totalCustomers,
	avg(score) avgScore
from Sales.Customers
where Country = @Country
end

exec GetCustomerSummary @Country = 'Germany'