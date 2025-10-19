
-- new table created
create table Sales.EmployeesLogs(
LogID int identity(1,1) primary key,
EmployeeID int,
LogMessage varchar(225),
LogDate datetime
)

-- trigger created
-- when some data is inserted into the table Sales.Employees
-- the query under the trigger is executed
create trigger trg_AfterInsertEmployee on Sales.Employees
after insert
as
begin
	insert into Sales.EmployeesLogs(EmployeeID, LogMessage, LogDate)
	select
		EmployeeID,
		'New Employee Added =' + cast(EmployeeID as varchar),
		GETDATE()
	from inserted
end

-- checking the trigger
select * from Sales.EmployeesLogs

insert into Sales.Employees
values(7,'Maria', 'Doe', 'HR' ,'1988-01-12', 'F', 80000, 3)