-- indexes
-- clustered index
select *
into Sales.DBCustomers
from Sales.Customers
-- by this a heap structure is being created


-- creating custom index
create clustered index idx_DBCustomers_CustomerID
on Sales.DBCustomers (CustomerID)

-- nonclustered index
create nonclustered index idx_DBCustomers_LastName
on Sales.DBCustomers(LastName)

-- composite index
create index idx_DBCustomers_CountryScore
on Sales.DBCustomers(Country,Score)


-- column-store indexes
-- first deleting the index which was stored in row-stored index
drop index idx_DBCustomers_CustomerID on Sales.DBCustomers
-- now creating a column-stored index
create clustered columnstore index idx_DBCustomers_CS on Sales.DBCustomers
-- a table can only have 1 columnstore index


-- unique index
select * from Sales.Products

create unique nonclustered index idx_products_Category
on Sales.Products(ProductID)


-- filtered index
select * from Sales.Customers
where Country = 'USA'

create nonclustered index idx_customers_Country
on Sales.Customers(Country)
where Country = 'USA'


-- list all indexes on a specific table(stored procedures)
sp_helpindex 'Sales.DBCustomers'

-- monitoring index usage
select 
tbl.name as TableName,
idx.name as indexName,
idx.type_desc as IndexType,
/*idx.is_primary_key as IsUnique,
idx.is_unique as isUnique,
idx.is_disabled as IsDisabled*/
s.user_seeks as UserSeek,
s.user_scans as UserScan,
s.user_updates as UserUpdates,
coalesce(s.last_user_seek,s.last_user_scan) as LastUpdate
from sys.indexes idx
join sys.tables tbl
on idx.object_id = tbl.object_id
left join sys.dm_db_index_usage_stats s
on s.object_id = idx.object_id
and s.index_id = idx.index_id
order by tbl.name,idx.name


-- suggestion from the database to create indexes for a query
select * from sys.dm_db_missing_index_details

-- finding duplicate indexes
-- all the columncount having count as 2 are duplicates 
-- as same indexcolumn is being used in 2 indexes
select
	tbl.name as tablename,
	col.name as indexcolumn,
	idx.name as indexname,
	idx.type_desc as indextype,
	count(*) over(partition by tbl.name,col.name) columncount
from sys.indexes idx
join sys.tables tbl 
on idx.object_id = tbl.object_id
join sys.index_columns ic 
on idx.object_id = ic.object_id 
and idx.index_id = ic.index_id
join sys.columns col 
on ic.object_id = col.object_id
and ic.column_id = col.column_id
order by columncount desc


-- checking when the statistics were last updated
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    s.name AS StatisticName,
    sp.last_updated AS LastUpdate,
    DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdateDay,
    sp.rows AS 'Rows',
    sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables AS t
    ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY sp.modification_counter DESC;


-- Update all statistics for the Sales.DBCustomers table
UPDATE STATISTICS Sales.DBCustomers;

-- Update statistics for all tables in the database
EXEC sp_updatestats;


-- Fragmentation
-- Retrieve index fragmentation statistics for the current database
SELECT 
    tbl.name AS TableName,
    idx.name AS IndexName,
    s.avg_fragmentation_in_percent,
    s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s
INNER JOIN sys.tables tbl 
    ON s.object_id = tbl.object_id
INNER JOIN sys.indexes AS idx 
    ON idx.object_id = s.object_id
    AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC;

-- if fragmentation percent is > 10 and < 30 then reorganize
-- Reorganize the index (lightweight defragmentation)
ALTER INDEX idx_Customers_country 
ON Sales.Customers REORGANIZE;


-- if fragmentation percent is > 30 then rebuild
-- Rebuild the index (full rebuild, more resource-intensive)
ALTER INDEX idx_Customers_Country 
ON Sales.Customers REBUILD;

