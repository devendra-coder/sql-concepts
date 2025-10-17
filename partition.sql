-- partition
-- create partition function
create partition function PartitionByYear(date)
as range left for values('2023-12-31', '2024-12-31', '2025-12-31')


-- query lists of all existing partition function
select 
	name,
	function_id,
	type,
	type_desc,
	boundary_value_on_right
from sys.partition_functions


-- create Filegroups
alter database SalesDB add filegroup FG_2023;
alter database SalesDB add filegroup FG_2024;
alter database SalesDB add filegroup FG_2025;
alter database SalesDB add filegroup FG_2026;

-- Query list of all existing filegroups
select *
from sys.filegroups
where type = 'FG'


-- add .ndf files to each filegroup
alter database SalesDB add file
(
	name = p_2023, -- logical name
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\p_2023.ndf'
) to filegroup FG_2023;

alter database SalesDB add file
(
	name = p_2024, -- logical name
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\p_2024.ndf'
) to filegroup FG_2024;

alter database SalesDB add file
(
	name = p_2025, -- logical name
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\p_2025.ndf'
) to filegroup FG_2025;

alter database SalesDB add file
(
	name = p_2026, -- logical name
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\p_2026.ndf'
) to filegroup FG_2026;


-- query list of all files inside the database
select
	fg.name as FilegroupName,
	mf.name as LogicalFileName,
	mf.physical_name as PhysicalFilePath,
	mf.size / 128 as SizeInMB
from sys.filegroups fg
join
sys.master_files mf
on fg.data_space_id = mf.data_space_id
where mf.database_id = DB_ID('SalesDB');


-- creating partition schemes
CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026)

-- Query lists all Partition Scheme
SELECT 
    ps.name AS PartitionSchemeName,
    pf.name AS PartitionFunctionName,
    ds.destination_id AS PartitionNumber,
    fg.name AS FilegroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id


-- creating a partition table
CREATE TABLE Sales.Orders_Partitioned 
(
	OrderID INT,
	OrderDate DATE,
	Sales INT
) ON SchemePartitionByYear (OrderDate)

-- insert data into partition table
INSERT INTO Sales.Orders_Partitioned VALUES (1, '2023-05-15', 100);
INSERT INTO Sales.Orders_Partitioned VALUES (2, '2024-07-20', 50);
INSERT INTO Sales.Orders_Partitioned VALUES (3, '2025-12-31', 20);
INSERT INTO Sales.Orders_Partitioned VALUES (4, '2026-01-01', 100);


-- Verify Partitioning and Compare Execution Plans
-- Query: Verify that data is correctly partitioned and assigned to the appropriate filegroups 
SELECT 
    p.partition_number AS PartitionNumber,
    f.name AS PartitionFilegroup, 
    p.rows AS NumberOfRows 
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Orders_Partitioned';

